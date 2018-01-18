require 'optparse'
require_relative 'generator'

module Sinator

  class Command
    def self.parse(options)
      options = %w(--help) if options.empty? || options.nil?
      args = {}
      result = nil

      option_parser = OptionParser.new do |opts|
        opts.banner = "Usage: sinator [options]"

        opts.on("-h", "--help", "Print this help") do
          result = opts.to_s
        end

        opts.on("-v", "--version", "Show version") do
          result = Sinator::VERSION
        end

        opts.on("-nNAME", "--name=NAME", "generate app with name from this option") do |name|
          args[:name] = name
        end

        opts.on("-tDIR", "--target=DIR", "instead of current directory, generate app in target DIR") do |target|
          args[:target] = target
        end

        opts.on("-d", "--database", "add sequel orm for postgres sql") do
          args[:database] = true
        end

      end

      option_parser.parse! options

      result = run(args) unless args[:name].nil?

      result
    end

    def self.run(args)
      generator = Sinator::Generator.new args[:name],
        destination: args[:target], with_database: args[:database]

      generator.generate_app
      generator.generate_rakefile
      generator.generate_gemfile
      generator.generate_bundle_config
      generator.generate_puma_config

      msg = "#{args[:name]} is successfully generated"
      msg << " in #{args[:target]}" if args[:target]

      msg
    end
  end

end
