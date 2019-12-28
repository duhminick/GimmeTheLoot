import { GraphQLServer, PubSub } from 'graphql-yoga';
import mongoose from 'mongoose';
import { models } from './models';
import { Resolvers } from './graphql';

const db = mongoose.connect('mongodb://mongodb/gimmetheloot', {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

const pubsub = new PubSub();

const context = {
  models,
  db,
  pubsub
};

const server = new GraphQLServer({
  typeDefs: `${__dirname}/graphql/schema.graphql`,
  resolvers: Resolvers,
  context
});

const opts = {
  port: 5000,
};

if (process.env.TOKEN) {
  server.express.use((req, res, next) => {
    const { authorization } = req.headers;
    if (authorization != `Bearer ${process.env.TOKEN}`) {
      res.status(401).send('Unauthorized');
      return;
    }

    next();
  });
}

server.start(opts, () => {
  console.log('[API] Server is running on port 5000');
});