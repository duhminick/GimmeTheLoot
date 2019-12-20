import mongoose from 'mongoose';

export default mongoose.model('Item', new mongoose.Schema({
  name: String,
  url: String,
  price: Number
}));