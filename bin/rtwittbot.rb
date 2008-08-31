#!/usr/bin/env ruby
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'rtwittbot'))


include RTwittBot::Config

TwitterJabberBot.new(JABBER_ACCOUNT, TWITTER_ACCOUNT, ALLOWED_USER).go!
