require 'sinatra'
require 'sinatra/config_file'
require 'melodiest/setting'

module Melodiest
  class Application < Sinatra::Application
    extend Setting
    setup
  end
end
