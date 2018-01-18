ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require 'bundler'

Bundler.require :default, ENV['RACK_ENV'].to_sym

module Sinator
  ROOT = File.expand_path('../../', __FILE__)
end
