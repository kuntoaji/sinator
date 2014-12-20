require 'sinatra'

module Melodiest
  module Config
    def harmonize(&block)
      yield if block
    end
  end

  class Base < Sinatra::Base
    extend Config

    configure do
      harmonize
    end
  end

  class Application < Sinatra::Application
    extend Config

    configure do
      harmonize
    end
  end
end
