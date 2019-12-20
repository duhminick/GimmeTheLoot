import { models } from '../models';

export default {
  Query: {
    items: async (parent, args, { models }) => {
      const items = await models.Item.find({});
      return items;
    }
  },
  Mutation: {
    createItem: async (parent, { name, url, price }, { models }) => {
      const item = await models.Item.findOne({ url });

      if (item) {
        return false;
      }

      const newItem = models.Item({
        name,
        url,
        price
      });

      await newItem.save();

      return true;
    }
  }
};