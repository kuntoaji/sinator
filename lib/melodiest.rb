require 'sinatra'
require 'melodiest/setting'

module Melodiest
  class Application < Sinatra::Application
    extend Setting

    configure do
      setup
    end
  end
end
