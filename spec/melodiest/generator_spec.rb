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
        expected_file_content = File.read(File.expand_path("../../fixtures/without_db/gemfile.txt", __FILE__))

        expect(File.exists?(gemfile)).to be_truthy
        expect(file_content).to eq(expected_file_content)
      end
    end

    context "with database" do
      let(:gemfile) { "#{target_dir_with_db}/Gemfile" }

      it "should generate Gemfile with sequel" do
        generator_with_db.generate_gemfile
        file_content = File.read(gemfile)
        expected_file_content = File.read(File.expand_path("../../fixtures/with_db/gemfile.txt", __FILE__))

        expect(File.exists?(gemfile)).to be_truthy
        expect(file_content).to eq(expected_file_content)
      end
    end
  end

  describe "#generate_bundle_config" do
    let(:bundle_config) { "#{target_dir}/config.ru" }

    it "should generate config.ru with correct content" do
      generator.generate_bundle_config
      file_content = File.read(bundle_config)
      expected_file_content = File.read(File.expand_path("../../fixtures/config_ru.txt", __FILE__))

      expect(File.exists?(bundle_config)).to be_truthy
      expect(file_content).to eq(expected_file_content)
    end
  end

  describe "#generate_app" do
    before { FileUtils.rm_r @dest if Dir.exists?(@dest) }
    before { FileUtils.rm_r @dest_with_db if Dir.exists?(@dest_with_db) }

    it "generates home route" do
      generator.generate_app

      app_file = "#{target_dir}/app/routes/home.rb"
      erb_file = "#{target_dir}/app/routes/home.erb"
      file_content = File.read(app_file)
      expected_file_content = File.read(File.expand_path("../../fixtures/app_routes_home.txt", __FILE__))

      expect(File.exists?(app_file)).to be_truthy
      expect(File.exists?(erb_file)).to be_falsey
      expect(file_content).to eq expected_file_content
    end

    context "when generating without database" do
      describe "copy_templates" do
        let(:config_dir) { "#{target_dir}/config" }
        let(:assets_dir) { "#{target_dir}/assets" }
        let(:public_dir) { "#{target_dir}/public" }
        let(:without_db_sample_migration) { "#{target_dir}/db_migrations/000_example.rb" }

        it "copies from melodiest templates" do
          expect(File.exists?(config_dir)).to be_falsey
          expect(File.exists?(without_db_sample_migration)).to be_falsey
          expect(File.exists?(assets_dir)).to be_falsey
          expect(File.exists?(public_dir)).to be_falsey

          expect(Dir.exists?("#{target_dir}/app")).to be_falsey
          expect(Dir.exists?("#{target_dir}/app/routes")).to be_falsey
          expect(Dir.exists?("#{target_dir}/app/models")).to be_falsey
          expect(Dir.exists?("#{target_dir}/app/views")).to be_falsey
          expect(File.exists?("#{target_dir}/app/views/layout.erb")).to be_falsey
          expect(File.exists?("#{target_dir}/app/views/home/index.erb")).to be_falsey

          generator.generate_app

          expect(File.exists?(config_dir)).to be_truthy
          expect(File.exists?("#{config_dir}/database.yml.example")).to be_falsey
          expect(File.exists?(without_db_sample_migration)).to be_falsey
          expect(File.exists?(assets_dir)).to be_truthy
          expect(File.exists?(public_dir)).to be_truthy

          expect(Dir.exists?("#{target_dir}/app")).to be_truthy
          expect(Dir.exists?("#{target_dir}/app/routes")).to be_truthy
          expect(Dir.exists?("#{target_dir}/app/models")).to be_falsey
          expect(Dir.exists?("#{target_dir}/app/views")).to be_truthy
          expect(File.exists?("#{target_dir}/app/views/layout.erb")).to be_truthy
          expect(File.exists?("#{target_dir}/app/views/home/index.erb")).to be_truthy
        end
      end

      describe "app file" do
        let(:secret) { "supersecretcookiefromgenerator" }
        before { allow(SecureRandom).to receive(:hex).with(32).and_return(secret) }

        it "generates <app_name>.rb, public dir, and app dir" do
          generator.generate_app

          app_file = "#{target_dir}/my_app.rb"
          file_content = File.read(app_file)
          expected_file_content = File.read(File.expand_path("../../fixtures/without_db/app.txt", __FILE__))

          expect(File.exists?(app_file)).to be_truthy
          expect(file_content).to eq expected_file_content
        end
      end
    end

    context "when generating with database" do
      describe "copy templates" do
        let(:config_dir) { "#{target_dir_with_db}/config" }
        let(:assets_dir) { "#{target_dir_with_db}/assets" }
        let(:public_dir) { "#{target_dir_with_db}/public" }
        let(:with_db_sample_migration) { "#{target_dir_with_db}/db/migrations/000_example.rb" }

        it "copies from melodiest templates" do
          expect(File.exists?(config_dir)).to be_falsey
          expect(File.exists?("#{config_dir}/database.yml.example")).to be_falsey
          expect(File.exists?("#{config_dir}/boot.rb")).to be_falsey
          expect(File.exists?("#{config_dir}/application.rb")).to be_falsey

          expect(File.exists?(with_db_sample_migration)).to be_falsey
          expect(File.exists?(assets_dir)).to be_falsey
          expect(File.exists?(public_dir)).to be_falsey

          expect(Dir.exists?("#{target_dir_with_db}/app")).to be_falsey
          expect(Dir.exists?("#{target_dir_with_db}/app/routes")).to be_falsey
          expect(Dir.exists?("#{target_dir_with_db}/app/models")).to be_falsey
          expect(Dir.exists?("#{target_dir_with_db}/app/views")).to be_falsey
          expect(File.exists?("#{target_dir_with_db}/app/views/layout.erb")).to be_falsey
          expect(File.exists?("#{target_dir_with_db}/app/views/home/index.erb")).to be_falsey

          generator_with_db.generate_app

          expect(File.exists?(config_dir)).to be_truthy
          expect(File.exists?("#{config_dir}/database.yml.example")).to be_truthy
          expect(File.exists?("#{config_dir}/boot.rb")).to be_truthy
          expect(File.exists?("#{config_dir}/application.rb")).to be_truthy

          expect(File.exists?(with_db_sample_migration)).to be_truthy
          expect(File.exists?(assets_dir)).to be_truthy
          expect(File.exists?(public_dir)).to be_truthy

          expect(Dir.exists?("#{target_dir_with_db}/app")).to be_truthy
          expect(Dir.exists?("#{target_dir_with_db}/app/routes")).to be_truthy
          expect(Dir.exists?("#{target_dir_with_db}/app/models")).to be_truthy
          expect(Dir.exists?("#{target_dir_with_db}/app/views")).to be_truthy
          expect(File.exists?("#{target_dir_with_db}/app/views/layout.erb")).to be_truthy
          expect(File.exists?("#{target_dir_with_db}/app/views/home/index.erb")).to be_truthy
        end
      end

      describe "app file" do
        let(:secret) { "supersecretcookiefromgenerator" }
        before { allow(SecureRandom).to receive(:hex).with(32).and_return(secret) }

        it "has sequel database connector" do
          generator_with_db.generate_app

          app_file = "#{target_dir_with_db}/my_app.rb"
          file_content = File.read(app_file)
          expected_file_content = File.read(File.expand_path("../../fixtures/with_db/app.txt", __FILE__))

          expect(file_content).to eq expected_file_content
        end
      end
    end
  end

  describe "#generate_rakefile" do
    it "generate basic Rakefile tasks" do
      expected_rakefile_content =
      expected_rakefile_content = File.read(File.expand_path("../../fixtures/without_db/rakefile.txt", __FILE__))

      generator.generate_rakefile
      rakefile = "#{target_dir}/Rakefile"
      rakefile_content = File.read(rakefile)

      expect(rakefile_content).to eq expected_rakefile_content
    end

    context "with database" do
      it "generates db related tasks" do
        expected_rakefile_content = File.read(File.expand_path("../../fixtures/with_db/rakefile.txt", __FILE__))

        generator_with_db.generate_rakefile
        rakefile = "#{target_dir_with_db}/Rakefile"
        rakefile_content = File.read(rakefile)

        expect(rakefile_content).to eq expected_rakefile_content
      end
    end
  end

end
