FROM rocketchat/base:8

ENV RC_VERSION 0.70.0

MAINTAINER buildmaster@rocket.chat

ARG DATABASE_URL

RUN set -x \
 && curl -SLf "https://releases.rocket.chat/${RC_VERSION}/download/" -o rocket.chat.tgz \
 && curl -SLf "https://releases.rocket.chat/${RC_VERSION}/asc" -o rocket.chat.tgz.asc \
 && gpg --verify rocket.chat.tgz.asc \
 && mkdir -p /app \
 && tar -zxf rocket.chat.tgz -C /app \
 && rm rocket.chat.tgz rocket.chat.tgz.asc \
 && cd /app/bundle/programs/server \
 && npm install \
 && npm cache clear --force \
 && chown -R rocketchat:rocketchat /app

USER rocketchat

WORKDIR /app/bundle

# needs a mongoinstance - defaults to container linking with alias 'mongo'
ENV DEPLOY_METHOD=docker \
    NODE_ENV=production \
    MONGO_URL=DATABASE_URL \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 

EXPOSE 3000

CMD ["node", "main.js"]
