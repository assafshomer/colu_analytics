#!/bin/bash
source ~/.bash_profile
rvm use 2.2.0
gem install bundler
bundle install
bundle exec rake