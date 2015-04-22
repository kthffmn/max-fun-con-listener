require 'bundler/setup'
Bundler.require
Dotenv.load
require 'uri'
require 'open-uri'
require 'yaml'

require_relative "../lib/tweeter"
require_relative "../lib/app"
