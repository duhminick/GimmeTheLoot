import mongoose from 'mongoose';
import apn from 'apn';

let apnProvider = null;

if (process.env.ENABLE_APN) {
  apnProvider = new apn.Provider({
    cert: 'cert.pem',
    key: 'key.pem',
    production: false
  });
}

const schema = new mongoose.Schema({
  token: String
});

schema.methods.sendAPN = function (title, body, callback) {
  if (!process.env.ENABLE_APN || !apnProvider) {
    return;
  }

  let note = new apn.Notification();

  note.alert = {
    title,
    body
  };
  note.badge = 0;
  note.sound = 'default';
  // note.topic = process.env.BUNDLE_ID;

  apnProvider.send(note, this.token).then((result) => {
    console.log(result.failed);
  });
}

export default mongoose.model('Device', schema);
