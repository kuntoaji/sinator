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
  end

end
