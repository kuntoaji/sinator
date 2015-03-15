describe Melodiest::Auth::Http do
  it "respond to authorized!" do
    expect(Melodiest::Auth::Http.method_defined?(:authorized!)).to be_truthy
  end

  it "respond to authorized?" do
    expect(Melodiest::Auth::Http.method_defined?(:authorized?)).to be_truthy
  end

  it "returns 401 status code without authentication" do
    get "/protected"
    expect(last_response.status).to eq 401
  end

  it "returns 401 status code with bad authentication" do
    get "/protected"
    expect(last_response.status).to eq 401
  end

  it "returns 200 status code with good authentication" do
    authorize "admin", "admin"
    get "/protected"
    expect(last_response.status).to eq 200
  end
end
