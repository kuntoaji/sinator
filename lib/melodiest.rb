require 'sinatra'
require 'sinatra/reloader'
require 'melodiest/setting'

module Melodiest
  class Application < Sinatra::Application
    register Melodiest::Setting

    # http://www.sinatrarb.com/contrib/reloader.html
    configure :development do
      register Sinatra::Reloader
    end
  end
end
