FROM ruby:3.1.3-alpine

RUN apk add --update build-base shadow

RUN apk add --update postgresql-dev tzdata imagemagick bash openssh openssl nodejs npm yarn zsh git wget curl alpine-zsh-config

RUN addgroup -g 1000 qiscus && adduser -G qiscus -u 1000 qiscus -D

RUN mkdir -p /home/qiscus/app && chown -R qiscus:qiscus /home/qiscus/app

RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER qiscus

RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

ENV BUNDLER_VERSION=2.3.26
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev"

RUN gem update --system && gem install -N bundler -v ${BUNDLER_VERSION}

RUN gem install solargraph solargraph-rails foreman htmlbeautifier erb_lint brakeman rails

RUN solargraph download-core
