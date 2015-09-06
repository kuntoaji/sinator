require 'sinatra/base'
require 'encrypted_cookie'

module Melodiest
  class Application < Sinatra::Application
    def self.cookie_secret(secret)
      use Rack::Session::EncryptedCookie,
        secret: secret
    end

    # http://www.sinatrarb.com/contrib/reloader.html
    configure :development do
      require 'sinatra/reloader'
      register Sinatra::Reloader
    end
  end
end
