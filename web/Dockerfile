FROM node:12.10.0-alpine
WORKDIR /app

EXPOSE 3000

RUN npm install -g nodemon

COPY package.json /app/package.json
COPY yarn.lock /app/yarn.lock
RUN yarn install

COPY . /app
CMD ["yarn", "start"]