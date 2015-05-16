describe Melodiest::Setting do
  describe ".setup" do
    let(:my_app) do
      class MyApp < Melodiest::Application
        setup 'mysupersecretcookie', server: 'puma'
      end

      MyApp
    end

    it "set thin as server" do
      expect(app.settings.server).to eq("thin")
    end

    it "overrides default setting" do
      expect(my_app.settings.server).to eq("puma")
    end

    it "use encrypted cookie" do
      expect(my_app.instance_variable_get("@middleware")).to include
        [Rack::Session::EncryptedCookie, [{:secret => "mysupersecretcookie"}], nil]
    end

  end
end
