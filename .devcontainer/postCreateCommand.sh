#!/usr/bin/env bash

set -ex

git config --global --add safe.directory /home/qiscus/app

bundle install
solargraph bundle

rails db:environment:set RAILS_ENV=development

rails db:setup
