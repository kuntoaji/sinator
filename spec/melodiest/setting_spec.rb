require_relative '../../lib/melodiest/setting'

describe Melodiest::Setting do
  it "respond to setup" do
    expect(Melodiest::Setting.method_defined?(:setup)).to be_truthy
  end
end
