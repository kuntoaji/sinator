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

        opts.on("-tDIR", "--target=DIR", "instead of current directory, generate app in target DIR") do |target|
          args[:target] = target
        end

      end

      option_parser.parse! options

      result = run(args) unless args[:name].nil?

      result
    end

    def self.run(args)
      generator = Melodiest::Generator.new args[:name], destination: args[:target]

      generator.generate_gemfile
      generator.generate_bundle_config
      generator.generate_app

      msg = "#{args[:name]} is successfully generated"
      msg << " in #{args[:target]}" if args[:target]

      msg 
    end
  end

end
