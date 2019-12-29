import { models } from '../models';

const ITEM_ADDED = 'itemAdded';

export default {
  Query: {
    items: async (parent, args, { models }) => {
      const items = await models.Item.find({}).sort('-date');
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

      if (!item) {
        throw Error(`Monitor with id ${id} does not exist`);
      }

      return monitor;
    },
  },
  Mutation: {
    createItem: async (parent, { name, url, price, source }, { models, pubsub }) => {
      const item = await models.Item.findOne({ url });

      if (item) {
        throw Error(`Item with url ${url} already exists`);
      }

      const newItem = models.Item({
        name,
        url,
        price,
        source,
        archived: false
      });

      await newItem.save();

      pubsub.publish(ITEM_ADDED, { itemAdded: newItem });

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
    deleteMonitor: async (parent, { id }, { models }) => {
      const monitor = await models.Monitor.findOne({ _id: id });

      if (!monitor) {
        throw Error(`Monitor with id ${id} does not exist`);
      }

      monitor.deleteOne();

      return true
    },
  },
  Subscription: {
    itemAdded: {
      subscribe: (parent, args, { pubsub }) => {
        return pubsub.asyncIterator(ITEM_ADDED);
      }
    }
  }
};
