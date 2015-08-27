ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require 'bundler'

Bundler.require :default, ENV['RACK_ENV'].to_sym

module Melodiest
  ROOT = File.expand_path('../../', __FILE__)
end
