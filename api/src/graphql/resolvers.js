import { models } from '../models';

const ITEM_ADDED = 'itemAdded';

export default {
  Query: {
    items: async (parent, args, { models }) => {
      const items = await models.Item.find({});
      return items;
    },
    item: async (parent, { id } , { models }) => {
      const item = await models.Item.findOne({ _id: id });

      if (!item) {
        throw Error(`Item with id ${id} does not exist`);
      }

      return item;
    }
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
        source
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
