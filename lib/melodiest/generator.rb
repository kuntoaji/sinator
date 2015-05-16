require 'fileutils'
require 'securerandom'
require_relative 'version'

module Melodiest

  class Generator
    attr_accessor :destination, :app_name, :app_class_name

    def initialize(app_name, options={})
      @app_name = app_name
      @app_class_name = app_name.split("_").map{|s| s.capitalize }.join("")

      destination = options[:destination] ? "#{options[:destination]}/#{@app_name}" : @app_name
      @with_database = options[:with_database]

      unless File.directory?(destination)
        FileUtils.mkdir_p(destination)
      end

      @destination = File.expand_path(destination)
    end

    def generate_gemfile
      File.open "#{@destination}/Gemfile", "w" do |f|
        f.write("source 'https://rubygems.org'\n\n")
        f.write("gem 'melodiest', '#{Melodiest::VERSION}'\n")
        f.write("gem 'thin'\n")
        f.write("gem 'rack_csrf', require: 'rack/csrf'")

        if @with_database
          f.write("\ngem 'sequel'\n")
          f.write("gem 'sequel_pg', require: 'sequel'")
        end
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
      content = {}

      if @with_database
        content[:yaml] = "require 'yaml'\n\n"
        content[:database] = "    Sequel.connect YAML.load_file(File.expand_path(\"../config/database.yml\", __FILE__))[settings.environment.to_s]\n"
      else
        content[:yaml] = nil
        content[:database] = "    # Load up database and such\n"
      end

      File.open "#{@destination}/#{@app_name}.rb", "w" do |f|
        f.write(content[:yaml])
        f.write("class #{app_class_name} < Melodiest::Application\n")
        f.write("  setup '#{SecureRandom.hex(32)}'\n\n")
        f.write("  set :app_file, __FILE__\n")
        f.write("  set :views, Proc.new { File.join(root, \"app/views\") }\n\n")
        f.write("  use Rack::Csrf, raise: true\n\n")
        f.write("  configure do\n")
        f.write(content[:database])
        f.write("  end\n")
        f.write("end\n\n")
        f.write("%w{app/models app/routes}.each do |dir|\n")
        f.write("  Dir[File.join(dir, '**/*.rb')].each do |file|\n")
        f.write("    require_relative file\n")
        f.write("  end\n")
        f.write("end\n")
      end

      app_dir = "#{@destination}/app"
      ["", "/routes", "/models", "/views"].each do |dir|
        FileUtils.mkdir "#{app_dir}/#{dir}"
      end
    end

    def copy_templates
      FileUtils.cp_r File.expand_path("../templates/config", __FILE__), @destination

      if @with_database
        FileUtils.cp File.expand_path("../templates/Rakefile", __FILE__), @destination
        FileUtils.cp_r File.expand_path("../templates/db", __FILE__), @destination
      end
    end
  end

end
