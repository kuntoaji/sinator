require_relative '../../lib/melodiest/generator'

describe Melodiest::Generator do
  let(:generator) { Melodiest::Generator.new @app, destination: @dest }
  let(:target_dir) { "#{@dest}/#{@app}" }

  before :all do
    @dest = "/tmp/melodiest"
    @app = "my_app"
  end

  after :all do
    FileUtils.rm_r @dest
  end

  it "sets app_name" do
    expect(generator.app_name).to eq @app
  end

  it "sets app_class_name" do
    expect(generator.app_class_name).to eq "MyApp"
  end

  it "has default destination path app_name" do
    expect(Melodiest::Generator.new(@app).destination).to eq File.expand_path(@app)
  end

  it "sets new destination path even if it's not exist yet" do
    expect("/tmp/melodiest/my_app").to eq target_dir
  end

  describe "#generate_gemfile" do
    let(:gemfile) { "#{target_dir}/Gemfile" }

    it "should generate Gemfile with correct content" do
      generator.generate_gemfile
      file_content = File.read(gemfile)

      expect(File.exists?(gemfile)).to be_truthy
      expect(file_content).to include "source 'https://rubygems.org'"
      expect(file_content).to include "gem 'melodiest', '#{Melodiest::VERSION}'"
      expect(file_content).to include "gem 'thin'"
    end
  end

  describe "#generate_bundle_config" do
    let(:bundle_config) { "#{target_dir}/config.ru" }

    it "should generate config.ru with correct content" do
      generator.generate_bundle_config
      file_content = File.read(bundle_config)

      expect(File.exists?(bundle_config)).to be_truthy
      expect(file_content).to include "ENV['RACK_ENV'] ||= 'development'"
      expect(file_content).to include "require 'rubygems'"
      expect(file_content).to include "require 'bundler'"
      expect(file_content).to include "Bundler.require :default, ENV['RACK_ENV'].to_sym"
      expect(file_content).to include "require './my_app'"
      expect(file_content).to include "run MyApp"
    end
  end

  describe "#generate_app" do

    it "generates <app_name>.rb" do
      FileUtils.rm_r @dest if Dir.exists?(@dest)
      generator.generate_app
      app_file = "#{target_dir}/my_app.rb"
      file_content = File.read(app_file)

      expected_file_content =
<<DOC
class MyApp < Melodiest::Application
  setup

  set :app_file, __FILE__
  set :views, Proc.new { File.join(root, "app/views") }

  configure do
    # Load up database and such
  end
end

# Load all route files
Dir[File.dirname(__FILE__) + "/app/routes/**/*.rb"].each do |route|
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

    context "with sequel" do
      it "has sequel database connector" do
        FileUtils.rm_r @dest if Dir.exists?(@dest)
        generator_with_db = Melodiest::Generator.new @app, destination: @dest, with_database: true
        generator_with_db.generate_app
        app_file = "#{target_dir}/my_app.rb"
        file_content = File.read(app_file)

        expected_file_content =
<<DOC
require 'yaml'

class MyApp < Melodiest::Application
  setup

  set :app_file, __FILE__
  set :views, Proc.new { File.join(root, "app/views") }

  configure do
    Sequel.connect YAML.load_file(File.expand_path("../config/database.yml", __FILE__))[settings.environment.to_s]
  end
end

# Load all route files
Dir[File.dirname(__FILE__) + "/app/routes/**/*.rb"].each do |route|
  require route
end
DOC

        expect(file_content).to eq expected_file_content
      end
    end
  end

  describe "#copy_templates" do
    let(:config_dir) { "#{target_dir}/config" }

    it "copies config dir" do
      expect(File.exists?(config_dir)).to be_falsey
      expect(File.exists?("#{config_dir}/database.yml.example")).to be_falsey
      generator.copy_templates

      expect(File.exists?(config_dir)).to be_truthy
      expect(File.exists?("#{config_dir}/database.yml.example")).to be_truthy
    end
  end

end
