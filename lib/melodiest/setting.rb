module Melodiest
  module Setting
    def setup(cookie_secret, options={})
      {server: 'thin'}.merge(options).each do |key, value|
        set key, value
      end

      use Rack::Session::EncryptedCookie,
        secret: cookie_secret
    end
  end
end
