const Hapi = require('@hapi/hapi');
// const routes = require('./routes');

const server = Hapi.server({
  port: process.env.PORT || 8080,
  host: '0.0.0.0',
});

exports.init = async () => {
  // server.route(routes);
  await server.initialize();
  return server;
};

exports.start = async () => {
  // server.route(routes);
  await server.start();
  console.log(`Server running at: ${server.info.uri}`);
  return server;
};

process.on('unhandledRejection', err => {
  console.log('unhandledRejection ===> ', err);
  process.exit(1);
});
