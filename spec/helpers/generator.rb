module Helper
  module Generator
    def expected_gemfile(generator, target_dir, expected_gemfile)
      gemfile = "#{target_dir}/Gemfile"
      generator.generate_gemfile

      file_content = File.read(gemfile)
      expect(File.exists?(gemfile)).to be_truthy
      expect(file_content).to eq(expected_gemfile)
    end

    def expected_default_files(target_dir, expected_value)
      config_dir       = "#{target_dir}/config"
      assets_dir       = "#{target_dir}/assets"
      public_dir       = "#{target_dir}/public"
      boot             = "#{config_dir}/boot.rb"
      application      = "#{config_dir}/application.rb"

      app_dir          = "#{target_dir}/app"
      routes_dir       = "#{target_dir}/app/routes"
      views_dir        = "#{target_dir}/app/views"
      layout           = "#{target_dir}/app/views/layout.erb"
      home_index       = "#{target_dir}/app/views/home/index.erb"

      expect(File.exists?(config_dir)).to eq(expected_value)
      expect(File.exists?("#{config_dir}/boot.rb")).to eq(expected_value)
      expect(File.exists?("#{config_dir}/application.rb")).to eq(expected_value)
      expect(File.exists?(assets_dir)).to eq(expected_value)
      expect(File.exists?(public_dir)).to eq(expected_value)

      expect(Dir.exists?(app_dir)).to eq(expected_value)
      expect(Dir.exists?(routes_dir)).to eq(expected_value)
      expect(Dir.exists?(views_dir)).to eq(expected_value)
      expect(File.exists?(layout)).to eq(expected_value)
      expect(File.exists?(home_index)).to eq(expected_value)
    end

    def expected_generated_files_with_db(target_dir, expected_value)
      sample_migration = "#{target_dir}/db/migrations/000_example.rb"

      expect(Dir.exists?("#{target_dir}/app/models")).to eq(expected_value)
      expect(File.exists?("#{target_dir}/config/database.yml.example")).to eq(expected_value)
      expect(File.exists?(sample_migration)).to eq(expected_value)
    end

  end
end
