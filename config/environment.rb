ENV['SINATRA_ENV'] ||= 'development'

require 'bundler/setup'
require 'dotenv'
Dotenv.load
Bundler.require(:default, ENV['SINATRA_ENV'])

require_all 'app'
require_all 'lib'
