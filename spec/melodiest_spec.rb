describe Melodiest::Application do
  context ".settings" do
    it "use thin as server" do
      expect(app.settings.server).to eq("thin")
    end

    describe ".setup" do
      let(:my_app) do
        class MyApp < Melodiest::Application
          setup server: 'puma'
        end

        MyApp
      end

      it "overrides default setting" do
        expect(my_app.settings.server).to eq("puma")
      end
    end
  end

  context ".extensions" do
    it "has reloader extension" do
      expect(app.extensions.include?(Sinatra::Reloader)).to be_truthy
    end
  end
end
