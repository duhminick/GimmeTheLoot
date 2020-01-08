import { models } from '../models';

const ITEM_ADDED = 'itemAdded';

export default {
  Query: {
    items: async (parent, { archived }, { models }) => {
      const items = await models.Item.find({ archived }).sort('-date');
      return items;
    },
    item: async (parent, { id }, { models }) => {
      const item = await models.Item.findOne({ _id: id });

      if (!item) {
        throw Error(`Item with id ${id} does not exist`);
      }

      return item;
    },
    monitors: async (parent, args, { models }) => {
      const monitors = await models.Monitor.find({});
      return monitors;
    },
    monitor: async (parent, { id }, { models }) => {
      const monitor = await models.Monitor.findOne({ _id: id });

      if (!monitor) {
        throw Error(`Monitor with id ${id} does not exist`);
      }

      return monitor;
    },
  },
  Mutation: {
    createItem: async (parent, { name, url, price, source }, { models, pubsub }) => {
      const item = await models.Item.findOne({ url });
      let itemOfInterest = null;

      if (item && price && item.price && price >= item.price) {
        // Not cheaper and it already exists
        throw Error(`Item with url ${url} is not cheaper than it has been previously`)
      } else if (item && price && item.price && price < item.price) {
        // Update if cheaper

        await models.Item.updateOne({ url }, {
          price,
          archived: false,
          date: Date.now()
        });

        itemOfInterest = models.Item.findOne({ url });
      } else if (item) {
        // No price and it already exists

        throw Error(`Item with url ${url} already exists`);
      } else {
        // New - so it does not exist

        const newItem = models.Item({
          name,
          url,
          price,
          source,
          archived: false
        });

        await newItem.save();

        itemOfInterest = newItem;
      }

      pubsub.publish(ITEM_ADDED, { itemAdded: itemOfInterest });

      if (process.env.ENABLE_APN) {
        const devices = await models.Device.find({});
        for (const device of devices) {
          let body = `${source}`;
          if (price) {
            body = `$${price} - ${source}`;
          }

          device.sendAPN(name, body);
        }
      }

      return true;
    },
    deleteItem: async (parent, { id }, { models }) => {
      const item = await models.Item.findOne({ _id: id });

      if (!item) {
        throw Error(`Item with id ${id} does not exist`);
      }

      item.deleteOne();

      return true;
    },
    archiveItem: async (parent, { id }, { models }) => {
      const item = await models.Item.findOne({ _id: id });

      if (!item) {
        throw Error(`Item with id ${id} does not exist`);
      }

      await models.Item.updateOne({ _id: id }, {
        archived: true
      });

      return true;
    },
    deleteAllItems: async (parent, args, { models }) => {
      await models.Item.deleteMany({});
      return true;
    },
    archiveAllItems: async (parent, args, { models }) => {
      await models.Item.updateMany({}, {
        archived: true
      });
      return true;
    },
    createMonitor: async (parent, { name, type, keywords, url }, { models }) => {
      const newItem = models.Monitor({
        name,
        type,
        keywords,
        url
      });

      await newItem.save();

      return true;
    },
    updateMonitor: async (parent, args, { models }) => {
      const { id } = args;

      const monitor = await models.Monitor.findOne({ _id: id });

      if (!monitor) {
        throw Error(`Monitor with id ${id} does not exist`);
      }

      await models.Monitor.updateOne({ _id: id }, {
        ...args
      });

      return true;
    },
    deleteMonitor: async (parent, { id }, { models }) => {
      const monitor = await models.Monitor.findOne({ _id: id });

      if (!monitor) {
        throw Error(`Monitor with id ${id} does not exist`);
      }

      monitor.deleteOne();

      return true
    },
    createDevice: async (parent, { token }, { models }) => {
      const newDevice = models.Device({
        token
      });

      await newDevice.save();

      return true;
    },
    deleteDevice: async (parent, { id }, { models }) => {
      const device = await models.Device.findOne({ _id: id });

      if (!device) {
        throw Error(`Device with id ${id} does not exist`);
      }

      device.deleteOne();

      return true
    }
  },
  Subscription: {
    itemAdded: {
      subscribe: (parent, args, { pubsub }) => {
        return pubsub.asyncIterator(ITEM_ADDED);
      }
    }
  }
};
