module Melodiest
  module Setting
    def setup(cookie_secret, options={})
      settings = {
        server: 'thin'
      }.merge(options)

      settings.each do |key, value|
        set key, value
      end

      use Rack::Session::EncryptedCookie,
        secret: cookie_secret
    end
  end
end
