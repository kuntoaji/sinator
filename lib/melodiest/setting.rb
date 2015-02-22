module Melodiest
  module Setting
    def setup
      register Sinatra::ConfigFile
      config_file File.expand_path('../config.yml', __FILE__)
    end
  end
end
