require_relative '../../lib/melodiest/command'

describe Melodiest::Command do

  describe "parse" do
    before do
      FileUtils.rm_r "my_app" if Dir.exists?("my_app")
      FileUtils.rm_r "/tmp/my_app" if Dir.exists?("/tmp/my_app")
    end

    after :all do
      FileUtils.rm_r "my_app" if Dir.exists?("my_app")
      FileUtils.rm_r "/tmp/my_app" if Dir.exists?("/tmp/my_app")
    end

    it "has --help option" do
      help = Melodiest::Command.parse %w(--help)

      expect(help).to include "Usage: melodiest [options]"
      expect(help).to include "Print this help"
    end

    it "has --version option" do
      version = Melodiest::Command.parse %w(--version)

      expect(version).to include Melodiest::VERSION
    end

    it "has --name option as required option to generate application" do
      app = Melodiest::Command.parse %w(--name my_app)

      expect(app).to include "my_app is successfully generated"
    end

    it "has --target option as target directory" do
      app = Melodiest::Command.parse %w(-n my_app --target /tmp)

      expect(app).to include "my_app is successfully generated in /tmp"
      expect(Dir.exists?("/tmp/my_app")).to be_truthy
    end

    it "has --database option" do
      app = Melodiest::Command.parse %w(-n my_app --target /tmp -d)

      puts `ls /tmp/my_app`
      expect(app).to include "my_app is successfully generated in /tmp"
      expect(Dir.exists?("/tmp/my_app/db")).to be_truthy
    end

    context "when has no --name option and only --target option" do
      it "does nothing" do
        app = Melodiest::Command.parse %w(--target /tmp/melodiest)

        expect(app).to be_empty
      end
    end
  end

end
