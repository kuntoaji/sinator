module Melodiest
  module Setting
    def setup(options={})
      settings = {
        server: 'thin'
      }.merge(options)

      settings.each do |key, value|
        set key, value
      end
    end
  end
end
