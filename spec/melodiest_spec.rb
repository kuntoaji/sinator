describe Melodiest::Application do
  it "has config.yml" do
    expect(File.exists?(File.expand_path('../../lib/melodiest/config.yml', __FILE__))).to be_truthy
  end

  context ".settings" do
    it "use thin as server" do
      expect(Melodiest::Application.settings.server).to eq("thin")
    end
  end
end
