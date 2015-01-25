require_relative '../lib/melodiest'

describe Melodiest::Application do
  context ".settings" do
    it "use thin as server" do
      expect(Melodiest::Application.settings.server).to eq("thin")
    end
  end
end
