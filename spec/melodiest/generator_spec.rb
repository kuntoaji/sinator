require_relative '../../lib/melodiest/generator'

describe Melodiest::Generator do
  let(:generator) { Melodiest::Generator.new @app, destination: @dest }
  let(:generator_with_db) { Melodiest::Generator.new @app, destination: @dest_with_db, with_database: true }
  let(:target_dir) { "#{@dest}/#{@app}" }
  let(:target_dir_with_db) { "#{@dest_with_db}/#{@app}" }

  before :all do
    @dest = "/tmp/melodiest"
    @dest_with_db = "#{@dest}_with_db"
    @app = "my_app"
  end

  before :all do
    FileUtils.rm_r @dest if Dir.exists?(@dest)
    FileUtils.rm_r @dest_with_db if Dir.exists?(@dest_with_db)
  end

  after :all do
    FileUtils.rm_r @dest
    FileUtils.rm_r @dest_with_db
  end

  it "sets app_name" do
    expect(generator.app_name).to eq @app
  end

  it "sets app_class_name" do
    expect(generator.app_class_name).to eq "MyApp"
  end

  it "has default destination path app_name" do
    FileUtils.rm_r @app if Dir.exists?(@app)
    expect(Melodiest::Generator.new(@app).destination).to eq File.expand_path(@app)
    FileUtils.rm_r @app
  end

  it "sets new destination path even if it's not exist yet" do
    expect("/tmp/melodiest/my_app").to eq target_dir
  end

  describe "#generate_gemfile" do
    context "without database" do
      let(:gemfile) { "#{target_dir}/Gemfile" }

      it "should generate Gemfile without sequel" do
        generator.generate_gemfile
        file_content = File.read(gemfile)

        expect(File.exists?(gemfile)).to be_truthy
        expect(file_content).to include "source 'https://rubygems.org'"
        expect(file_content).to include "gem 'melodiest', '#{Melodiest::VERSION}'"
        expect(file_content).to include "gem 'thin'"
        expect(file_content).to include "gem 'tux', require: false"
        expect(file_content).to include "gem 'rack_csrf', require: 'rack/csrf'"
        expect(file_content).to include "gem 'sinatra-asset-pipeline', require: 'sinatra/asset_pipeline'"
        expect(file_content).to include "gem 'uglifier', require: false"
        expect(file_content).to_not include "gem 'sequel'"
        expect(file_content).to_not include "gem 'sequel_pg'"
      end
    end

    context "with database" do
      let(:gemfile) { "#{target_dir_with_db}/Gemfile" }

      it "should generate Gemfile with sequel" do
        generator_with_db.generate_gemfile
        file_content = File.read(gemfile)
        expect(file_content).to include "gem 'sequel'"
        expect(file_content).to include "gem 'sequel_pg'"
      end
    end
  end

  describe "#generate_bundle_config" do
    let(:bundle_config) { "#{target_dir}/config.ru" }

    it "should generate config.ru with correct content" do
      generator.generate_bundle_config
      file_content = File.read(bundle_config)

      expect(File.exists?(bundle_config)).to be_truthy
      expect(file_content).to include "require File.expand_path('../config/boot.rb', __FILE__)"
      expect(file_content).to include "require Melodiest::ROOT + '/#{@app}'"
      expect(file_content).to include "require Melodiest::ROOT + '/config/application'"
      expect(file_content).to include "run MyApp"
    end
  end

  describe "#generate_app" do
    let(:secret) { "supersecretcookiefromgenerator" }
    before { allow(SecureRandom).to receive(:hex).with(32).and_return(secret) }

    it "generates <app_name>.rb, public dir, and app dir" do
      FileUtils.rm_r target_dir if Dir.exists?(target_dir)
      generator.generate_app
      app_file = "#{target_dir}/my_app.rb"
      file_content = File.read(app_file)

      expected_file_content =
<<DOC
class MyApp < Melodiest::Application
  setup '#{secret}'

  set :app_file, __FILE__
  set :views, Proc.new { File.join(root, "app/views") }
  set :assets_css_compressor, :sass
  set :assets_js_compressor, :uglifier

  register Sinatra::AssetPipeline
  use Rack::Csrf, raise: true

  configure do
    # Load up database and such
  end
end
DOC

      expect(File.exists?(app_file)).to be_truthy
      expect(file_content).to eq expected_file_content
      expect(Dir.exists?("#{target_dir}/public")).to be_truthy
      expect(Dir.exists?("#{target_dir}/app")).to be_truthy
      expect(Dir.exists?("#{target_dir}/app/routes")).to be_truthy
      expect(Dir.exists?("#{target_dir}/app/models")).to be_truthy
      expect(Dir.exists?("#{target_dir}/app/views")).to be_truthy
    end

    context "with sequel" do
      it "has sequel database connector" do
        FileUtils.rm_r target_dir_with_db if Dir.exists?(target_dir_with_db)
        generator_with_db.generate_app
        app_file = "#{target_dir_with_db}/my_app.rb"
        file_content = File.read(app_file)

        expected_file_content =
<<DOC
require 'yaml'

class MyApp < Melodiest::Application
  setup '#{secret}'

  set :app_file, __FILE__
  set :views, Proc.new { File.join(root, "app/views") }
  set :assets_css_compressor, :sass
  set :assets_js_compressor, :uglifier

  register Sinatra::AssetPipeline
  use Rack::Csrf, raise: true

  configure :development, :test do
    require 'logger'

    Sequel.connect YAML.load_file(File.expand_path("../config/database.yml", __FILE__))[settings.environment.to_s],
      loggers: [Logger.new($stdout)]
  end

  configure :production do
    Sequel.connect YAML.load_file(File.expand_path("../config/database.yml", __FILE__))['production']
  end
end
DOC

        expect(file_content).to eq expected_file_content
      end
    end
  end

  describe "#copy_templates" do
    context "when generating without database" do
      let(:config_dir) { "#{target_dir}/config" }
      let(:assets_dir) { "#{target_dir}/assets" }
      let(:without_db_sample_migration) { "#{target_dir}/db_migrations/000_example.rb" }

      it "only copies assets dir" do
        expect(File.exists?(config_dir)).to be_falsey
        expect(File.exists?(without_db_sample_migration)).to be_falsey
        expect(File.exists?(assets_dir)).to be_falsey
        generator.copy_templates

        expect(File.exists?(config_dir)).to be_truthy
        expect(File.exists?("#{config_dir}/database.yml.example")).to be_falsey
        expect(File.exists?(without_db_sample_migration)).to be_falsey
        expect(File.exists?(assets_dir)).to be_truthy
      end
    end

    context "when generating with database" do
      let(:config_dir) { "#{target_dir_with_db}/config" }
      let(:assets_dir) { "#{target_dir_with_db}/assets" }
      let(:with_db_sample_migration) { "#{target_dir_with_db}/db/migrations/000_example.rb" }

      it "copies assets, config, and Rakefile" do
        expect(File.exists?(config_dir)).to be_falsey
        expect(File.exists?("#{config_dir}/database.yml.example")).to be_falsey
        expect(File.exists?("#{config_dir}/boot.rb")).to be_falsey
        expect(File.exists?("#{config_dir}/application.rb")).to be_falsey
        expect(File.exists?(with_db_sample_migration)).to be_falsey
        expect(File.exists?(assets_dir)).to be_falsey

        generator_with_db.copy_templates

        expect(File.exists?(config_dir)).to be_truthy
        expect(File.exists?("#{config_dir}/database.yml.example")).to be_truthy
        expect(File.exists?("#{config_dir}/boot.rb")).to be_truthy
        expect(File.exists?("#{config_dir}/application.rb")).to be_truthy
        expect(File.exists?(with_db_sample_migration)).to be_truthy
        expect(File.exists?(assets_dir)).to be_truthy
      end
    end
  end

  describe "#generate_rakefile" do
    it "generate basic Rakefile tasks" do
      expected_rakefile_content =
<<RAKEFILE
require_relative 'config/boot'
require_relative '#{@app}'
require 'sinatra/asset_pipeline/task'

Sinatra::AssetPipeline::Task.define! MyApp
RAKEFILE

      generator.generate_rakefile
      rakefile = "#{target_dir}/Rakefile"
      rakefile_content = File.read(rakefile)

      expect(rakefile_content).to eq expected_rakefile_content
    end

    context "with database" do
      it "generates db related tasks" do

        expected_rakefile_content =
<<RAKEFILE
require_relative 'config/boot'
require_relative '#{@app}'
require 'sinatra/asset_pipeline/task'

Sinatra::AssetPipeline::Task.define! MyApp

namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    Sequel.extension :migration
    db = Sequel.connect(YAML.load_file("\#{Melodiest::ROOT}/config/database.yml")[ENV['RACK_ENV']])
    migration_path = "\#{Melodiest::ROOT}/db/migrations"

    if args[:version]
      puts "Migrating to version \#{args[:version]}"
      Sequel::Migrator.run(db, migration_path, target: args[:version].to_i)
    else
      puts "Migrating to latest"
      Sequel::Migrator.run(db, migration_path)
    end
  end
end
RAKEFILE

        generator_with_db.generate_rakefile
        rakefile = "#{target_dir_with_db}/Rakefile"
        rakefile_content = File.read(rakefile)

        expect(rakefile_content).to eq expected_rakefile_content
      end
    end
  end

end
