require_relative '../lib/melodiest'

describe Melodiest::Config do
  it "respond to harmonize_settings" do
    expect(Melodiest::Config.method_defined?(:harmonize_settings)).to be_truthy
  end
end

describe Melodiest::Application do
  context ".settings" do
    it "use thin as server" do
      expect(Melodiest::Application.settings.server).to eq("thin")
    end
  end
end
