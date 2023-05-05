FROM ruby:3.1.3-alpine

RUN apk add --update build-base

RUN apk add --update postgresql-dev tzdata imagemagick bash openssh openssl nodejs npm yarn

RUN addgroup -g 1000 qiscus && adduser -G qiscus -u 1000 qiscus -D

RUN mkdir -p /home/qiscus/app && chown -R qiscus:qiscus /home/qiscus/app

RUN apk --no-cache add wget curl

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t robbyrussell

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER qiscus

ENV BUNDLER_VERSION=2.3.26
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"

RUN gem update --system && gem install -N bundler -v ${BUNDLER_VERSION}

RUN gem install solargraph foreman htmlbeautifier erb_lint brakeman rails
RUN solargraph download-core
