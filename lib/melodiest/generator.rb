require 'fileutils'
require_relative 'version'

module Melodiest

  class Generator
    attr_accessor :destination, :app_name, :app_class_name

    def initialize(app_name, destination=nil)
      @app_name = app_name
      @app_class_name = app_name.split("_").map{|s| s.capitalize }.join("")
      destination = destination ? "#{destination}/#{@app_name}" : @app_name

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

    def generate_bundle_config
      File.open "#{@destination}/config.ru", "w" do |f|
        f.write("ENV['RACK_ENV'] ||= 'development'\n\n")
        f.write("require 'rubygems'\n")
        f.write("require 'bundler'\n\n")
        f.write("Bundler.require :default, ENV['RACK_ENV'].to_sym\n\n")
        f.write("require './#{@app_name}'\n")
        f.write("run #{@app_class_name}\n")
      end
    end

    # https://github.com/sinatra/sinatra-book/blob/master/book/Organizing_your_application.markdown
    def generate_app
      File.open "#{@destination}/#{@app_name}.rb", "w" do |f|
        f.write("class #{app_class_name} < Melodiest::Application\n")
        f.write("  configure do\n")
        f.write("    # Load up database and such\n")
        f.write("  end\n")
        f.write("end\n\n")
        f.write("# Load all route files\n")
        f.write("Dir[File.dirname(__FILE__) + \"/app/routes/**\"].each do |route|\n")
        f.write("  require route\n")
        f.write("end\n")
      end

      FileUtils.mkdir_p "#{@destination}/db/migrations"

      app_dir = "#{@destination}/app"
      ["", "/routes", "/models", "/views"].each do |dir|
        FileUtils.mkdir "#{app_dir}/#{dir}"
      end
    end
  end

end
