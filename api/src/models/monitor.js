import mongoose from 'mongoose';

export default mongoose.model('Monitor', new mongoose.Schema({
  name: String,
  type: String,
  keywords: [String],
  url: String
}));