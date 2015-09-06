module Melodiest
  module Setting
    def setup(cookie_secret)
      use Rack::Session::EncryptedCookie,
        secret: cookie_secret
    end
  end
end
