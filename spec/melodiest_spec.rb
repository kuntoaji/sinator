describe Melodiest::Application do
  context ".extensions" do
    it "has reloader extension" do
      expect(app.extensions.include?(Sinatra::Reloader)).to be_truthy
    end
  end
end
