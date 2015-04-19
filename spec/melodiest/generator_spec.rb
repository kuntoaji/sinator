require_relative '../../lib/melodiest/generator'
require 'fakefs/spec_helpers'

describe Melodiest::Generator do
  include FakeFS::SpecHelpers

  let(:dest) { "/tmp/melodiest" }
  let(:app) { "my_app" }
  let(:generator) { Melodiest::Generator.new app, dest }

  it "sets app_name" do
    expect(generator.app_name).to eq app
  end

  it "sets app_class_name" do
    expect(generator.app_class_name).to eq "MyApp"
  end

  it "has default destination path app_name" do
    expect(Melodiest::Generator.new(app).destination).to eq File.expand_path(app)
  end

  it "sets new destination path even if it's not exist yet" do
    expect("/tmp/melodiest/my_app").to eq "#{dest}/#{app}"
  end

  describe "#generate_gemfile" do
    let(:gemfile) { "#{dest}/#{app}/Gemfile" }

    it "should generate Gemfile with correct content" do
      generator.generate_gemfile
      file_content = File.read(gemfile)

      expect(File.exists?(gemfile)).to be_truthy
      expect(file_content).to include "source 'https://rubygems.org'"
      expect(file_content).to include "gem 'melodiest', '#{Melodiest::VERSION}'"
    end
  end

  describe "#generate_bundle_config" do
    let(:bundle_config) { "#{dest}/#{app}/config.ru" }

    it "should generate config.ru with correct content" do
      generator.generate_bundle_config
      file_content = File.read(bundle_config)

      expect(File.exists?(bundle_config)).to be_truthy
      expect(file_content).to include "require 'rubygems'"
      expect(file_content).to include "require 'bundler'"
      expect(file_content).to include "Bundler.require"
      expect(file_content).to include "require './my_app'"
      expect(file_content).to include "run MyApp"
    end
  end

  describe "#generate_app" do
    let(:target_dir) { "#{dest}/#{app}" }

    it "generates <app_name>.rb" do
      generator.generate_app
      app_file = "#{target_dir}/my_app.rb"
      file_content = File.read(app_file)

      expected_file_content =
<<DOC
class MyApp < Melodiest::Application
  configure do
    # Load up database and such
  end
end

# Load all route files
Dir[File.dirname(__FILE__) + "/app/routes/**"].each do |route|
  require route
end
DOC

      expect(File.exists?(app_file)).to be_truthy
      expect(file_content).to eq expected_file_content
      expect(Dir.exists?("#{target_dir}/db/migrations")).to be_truthy
      expect(Dir.exists?("#{target_dir}/app")).to be_truthy
      expect(Dir.exists?("#{target_dir}/app/routes")).to be_truthy
      expect(Dir.exists?("#{target_dir}/app/models")).to be_truthy
      expect(Dir.exists?("#{target_dir}/app/views")).to be_truthy
    end
  end

end
