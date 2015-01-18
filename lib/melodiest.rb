require 'sinatra'

module Melodiest
  module Config
    def harmonize_settings
      set :server, 'thin'
    end
  end

  class Application < Sinatra::Application
    extend Config

    configure do
      harmonize_settings
    end
  end
end
