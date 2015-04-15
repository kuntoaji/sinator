require_relative '../../lib/melodiest/generator'
require 'fakefs/spec_helpers'

describe Melodiest::Generator do
  include FakeFS::SpecHelpers

  let(:dest) { "/tmp/melodiest" }
  let(:generator) { Melodiest::Generator.new dest }

  it "has default destination path" do
    expect(Melodiest::Generator.new.destination).to eq File.expand_path(".")
  end

  it "sets new destination path even if it's not exist yet" do
    expect(generator.destination).to eq dest
  end

  describe "#generate_gemfile" do
    let(:gemfile) { "#{dest}/Gemfile" }

    it "should generate Gemfile with correct content" do
      generator.generate_gemfile
      file_content = File.read(gemfile)

      expect(File.exists?(gemfile)).to be_truthy
      expect(file_content).to include "source 'https://rubygems.org'"
      expect(file_content).to include "gem 'melodiest', '#{Melodiest::VERSION}'"
    end
  end

  describe "#generate_bundle_config" do
    let(:bundle_config) { "#{dest}/config.ru" }

    it "should generate config.ru with correct content" do
      generator.generate_bundle_config "MyApplication"
      file_content = File.read(bundle_config)

      expect(File.exists?(bundle_config)).to be_truthy
      expect(file_content).to include "require 'rubygems'"
      expect(file_content).to include "require 'bundler'"
      expect(file_content).to include "Bundler.require"
      expect(file_content).to include "require './boot'"
      expect(file_content).to include "run MyApplication"
    end
  end

end
