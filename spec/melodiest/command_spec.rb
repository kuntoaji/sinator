require_relative '../../lib/melodiest/command'
require 'fakefs/spec_helpers'

describe Melodiest::Command do
  include FakeFS::SpecHelpers

  describe "parse" do
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

    it "has --directory option as target directory" do
      app = Melodiest::Command.parse %w(-n my_app --dir /tmp/melodiest)

      expect(app).to include "my_app is successfully generated in /tmp/melodiest"
    end

    context "when has no --name option and only --dir option" do
      it "does nothing" do
        app = Melodiest::Command.parse %w(--dir /tmp/melodiest)

        expect(app).to be_empty
      end
    end
  end
end
