require_relative '../../lib/melodiest/generator'
require 'fakefs/spec_helpers'

describe Melodiest::Generator do
  include FakeFS::SpecHelpers

  let(:dest) { "/tmp/melodiest" }

  it "has default destination path" do
    expect(Melodiest::Generator.new.destination).to eq File.expand_path(".")
  end

  it "sets new destination path even if it's not exist yet" do
    FakeFS do
      generator = Melodiest::Generator.new dest
      expect(generator.destination).to eq dest
    end
  end

  describe "#generate_gemfile" do
    let(:gemfile) { "#{dest}/Gemfile" }

    it "should generate Gemfile with correct content" do
      FakeFS do
        generator = Melodiest::Generator.new dest
        generator.generate_gemfile
        expect(File.exists?(gemfile)).to be_truthy
        expect(File.read(gemfile)).to include "source 'https://rubygems.org'"
        expect(File.read(gemfile)).to include "gem 'melodiest', '#{Melodiest::VERSION}'"
      end
    end
  end

end
