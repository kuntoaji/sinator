require 'fileutils'

module Melodiest

  class Generator
    attr_accessor :destination

    def initialize(destination=".")
      unless File.directory?(destination)
        FileUtils.mkdir_p(destination)
      end

      @destination = File.expand_path(destination)
    end

    def generate_gemfile
      File.open "#{@destination}/Gemfile", "w" do |f|
        f.write("source 'https://rubygems.org'\n\n")
        f.write("gem 'melodiest', '#{Melodiest::VERSION}'")
      end
    end

    def generate_bundle_config(app_name)
      File.open "#{@destination}/config.ru", "w" do |f|
        f.write("require 'rubygems'\n")
        f.write("require 'bundler'\n\n")
        f.write("Bundler.require\n\n")
        f.write("require './boot'\n")
        f.write("run #{app_name}\n")
      end
    end
  end

end
