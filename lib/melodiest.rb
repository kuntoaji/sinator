require 'sinatra/base'
require 'sinatra/reloader'
require 'encrypted_cookie'
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
