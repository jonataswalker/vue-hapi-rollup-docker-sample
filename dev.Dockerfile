FROM node:12-alpine as builder

WORKDIR /home

COPY package*.json ./

# Install build toolchain, install node deps and compile native add-ons
# Configure NPM, Install pm2
RUN apk add --no-cache --virtual .gyp python make g++ \
  && mkdir /home/npm-global \
  && npm config set prefix '/home/npm-global' \
  && npm i pm2 -g \
  && npm i

FROM node:12-alpine

ENV NODE_ENV=development \
  NPM_CONFIG_LOGLEVEL=warn
ENV PATH /home/node/.npm-global/bin:${PATH}

# run as root
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER node
WORKDIR /www

# copy dependencies
COPY --from=builder /home/node_modules /tmp/node_modules/
COPY --from=builder /home/npm-global /home/node/.npm-global/

ENTRYPOINT ["docker-entrypoint.sh"]