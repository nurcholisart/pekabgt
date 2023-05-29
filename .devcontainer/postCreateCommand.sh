#!/usr/bin/env bash

set -ex

git config --global --add safe.directory /home/qiscus/app

bundle install
solargraph bundle

rails db:setup
