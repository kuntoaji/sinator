require 'optparse'
require_relative 'generator'

module Melodiest

  class Command
    def self.parse(options)
      args = {name: nil, dir: nil}
      result = ""

      option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: melodiest [options]"

        opts.on("-h", "--help", "Print this help") do
          result = opts.to_s
        end

        opts.on("-v", "--version", "Show version") do
          result = Melodiest::VERSION
        end

        opts.on("-nNAME", "--name=NAME", "generate app with name from this option") do |name|
          args[:name] = name
        end

        opts.on("-dDIR", "--dir=DIR", "instead of current directory, generate app in target DIR") do |dir|
          args[:dir] = dir
        end

      end

      option_parser.parse! options

      result = Command.run(args[:name], args[:dir]) unless args[:name].nil?

      result
    end

    def self.run(app_name, target_dir)
      generator = Melodiest::Generator.new app_name

      generator.generate_gemfile
      generator.generate_bundle_config
      generator.generate_app

      msg = "#{app_name} is successfully generated"
      msg << " in #{target_dir}" if target_dir

      msg 
    end
  end

end
