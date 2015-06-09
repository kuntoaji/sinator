require 'sinatra/base'
require 'encrypted_cookie'
require 'melodiest/setting'

module Melodiest
  class Application < Sinatra::Application
    register Melodiest::Setting

    # http://www.sinatrarb.com/contrib/reloader.html
    configure :development do
      require 'sinatra/reloader'
      register Sinatra::Reloader
    end
  end
end
