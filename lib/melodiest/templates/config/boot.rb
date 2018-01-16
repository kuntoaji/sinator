ENV['APP_ENV'] ||= 'development'

require 'rubygems'
require 'bundler'

Bundler.require :default, ENV['APP_ENV'].to_sym

module Melodiest
  ROOT = File.expand_path('../../', __FILE__)
end
