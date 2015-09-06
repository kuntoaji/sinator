describe Melodiest::Setting do
  describe ".setup" do
    let(:my_app) do
      class MyApp < Melodiest::Application
        setup 'mysupersecretcookie'
      end

      MyApp
    end


    it "use encrypted cookie" do
      expect(my_app.instance_variable_get("@middleware")).to include
        [Rack::Session::EncryptedCookie, [{:secret => "mysupersecretcookie"}], nil]
    end

  end
end
