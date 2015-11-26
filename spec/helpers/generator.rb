module Helper
  module Generator
    def expected_gemfile(generator, target_dir, expected_gemfile)
      gemfile = "#{target_dir}/Gemfile"
      generator.generate_gemfile

      file_content = File.read(gemfile)
      expect(File.exists?(gemfile)).to be_truthy
      expect(file_content).to eq(expected_gemfile)
    end
  end
end
