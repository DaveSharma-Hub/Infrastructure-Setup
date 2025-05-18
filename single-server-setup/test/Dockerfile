FROM node:23-slim

WORKDIR /opt/app

COPY . /opt/app/

RUN npm ci

CMD [ "node","index.js", "3000" ]