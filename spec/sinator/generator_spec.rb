require_relative '../../lib/sinator/generator'
require_relative '../helpers/generator'

describe Sinator::Generator do
  include Helper::Generator

  let(:generator) { Sinator::Generator.new @app, destination: @dest }
  let(:generator_with_db) { Sinator::Generator.new @app, destination: @dest_with_db, with_database: true }
  let(:target_dir) { "#{@dest}/#{@app}" }
  let(:target_dir_with_db) { "#{@dest_with_db}/#{@app}" }

  before do
    @dest = "/tmp/sinator"
    @dest_with_db = "#{@dest}_with_db"
    @app = "my_app"

    FileUtils.rm_r @dest if Dir.exist?(@dest)
    FileUtils.rm_r @dest_with_db if Dir.exist?(@dest_with_db)
  end

  after do
    FileUtils.rm_r @dest if Dir.exist?(@dest)
    FileUtils.rm_r @dest_with_db if Dir.exist?(@dest_with_db)
  end

  it "sets app_name" do
    expect(generator.app_name).to eq @app
  end

  it "sets app_class_name" do
    expect(generator.app_class_name).to eq "MyApp"
  end

  it "has default destination path app_name" do
    FileUtils.rm_r @app if Dir.exist?(@app)
    expect(Sinator::Generator.new(@app).destination).to eq File.expand_path(@app)
    FileUtils.rm_r @app if Dir.exist?(@app)
  end

  it "sets new destination path even if it's not exist yet" do
    expect(Sinator::Generator.new(@dest).destination).to eq File.expand_path(@dest)
  end

  describe "#generate_gemfile" do
    context "without database" do
      let(:gemfile) { "#{target_dir}/Gemfile" }
      let(:expected_gemfile) { File.expand_path("../../fixtures/without_db/gemfile.txt", __FILE__) }

      it "should generate Gemfile without sequel" do
        generator.generate_gemfile
        expect_file_eq(gemfile, expected_gemfile)
      end
    end

    context "with database" do
      let(:gemfile) { "#{target_dir_with_db}/Gemfile" }
      let(:expected_gemfile) { File.expand_path("../../fixtures/with_db/gemfile.txt", __FILE__) }

      it "should generate Gemfile with sequel" do
        generator_with_db.generate_gemfile
        expect_file_eq(gemfile, expected_gemfile)
      end
    end
  end

  describe "#generate_bundle_config" do
    let(:bundle_config) { "#{target_dir}/config.ru" }
    let(:expected_bundle_config) { File.expand_path("../../fixtures/config_ru.txt", __FILE__) }

    it "should generate config.ru with correct content" do
      generator.generate_bundle_config
      expect_file_eq(bundle_config, expected_bundle_config)
    end
  end

  describe "#generate_puma_config" do
    it "should generate puma config with correct content" do
      FileUtils.mkdir_p("#{target_dir}/config/puma")

      generator.generate_puma_config

      puma_development = "#{target_dir}/config/puma/development.rb"
      puma_production = "#{target_dir}/config/puma/production.rb"
      expected_puma_development = File.expand_path("../../fixtures/config/puma/development.txt", __FILE__)
      expected_puma_production = File.expand_path("../../fixtures/config/puma/production.txt", __FILE__)

      expect_file_eq(puma_development, expected_puma_development)
      expect_file_eq(puma_production, expected_puma_production)
    end
  end

  describe "#generate_app" do
    it "generates home route" do
      generator.generate_app

      erb_file = "#{target_dir}/app/routes/home.erb"
      generated_file = "#{target_dir}/app/routes/home.rb"
      expected_file = File.expand_path("../../fixtures/app_routes_home.txt", __FILE__)

      expect(File.exist?(erb_file)).to be_falsey
      expect(File.exist?(generated_file)).to be_truthy
      expect_file_eq(generated_file, expected_file)
    end

    context "when generating without database" do
      describe "copy_templates" do
        it "copies from sinator templates" do
          expected_default_files(target_dir, false)
          expected_generated_files_with_db(target_dir, false)

          generator.generate_app

          expected_default_files(target_dir, true)
          expected_generated_files_with_db(target_dir, false)
        end
      end

      describe "app file" do
        let(:secret) { "supersecretcookiefromgenerator" }
        before { allow(SecureRandom).to receive(:hex).with(32).and_return(secret) }

        it "generates <app_name>.rb, public dir, and app dir" do
          generator.generate_app

          generated_file = "#{target_dir}/my_app.rb"
          expected_file = File.expand_path("../../fixtures/without_db/app.txt", __FILE__)

          expect_file_eq(generated_file, expected_file)
        end
      end
    end

    context "when generating with database" do
      describe "copy templates" do
        it "copies from sinator templates" do
          expected_default_files(target_dir_with_db, false)
          expected_generated_files_with_db(target_dir_with_db, false)

          generator_with_db.generate_app

          expected_default_files(target_dir_with_db, true)
          expected_generated_files_with_db(target_dir_with_db, true)
        end
      end

      describe "app file" do
        let(:secret) { "supersecretcookiefromgenerator" }
        before { allow(SecureRandom).to receive(:hex).with(32).and_return(secret) }

        it "has sequel database connector" do
          generator_with_db.generate_app

          generated_file = "#{target_dir_with_db}/my_app.rb"
          expected_file = File.expand_path("../../fixtures/with_db/app.txt", __FILE__)

          expect_file_eq(generated_file, expected_file)
        end
      end
    end
  end

  describe "#generate_rakefile" do
    it "generate basic Rakefile tasks" do
      generator.generate_rakefile

      generated_file = "#{target_dir}/Rakefile"
      expected_file = File.expand_path("../../fixtures/without_db/rakefile.txt", __FILE__)

      expect_file_eq(generated_file, expected_file)
    end

    context "with database" do
      it "generates db related tasks" do
        generator_with_db.generate_rakefile

        generated_file = "#{target_dir_with_db}/Rakefile"
        expected_file = File.expand_path("../../fixtures/with_db/rakefile.txt", __FILE__)

        expect_file_eq(generated_file, expected_file)
      end
    end
  end

end
