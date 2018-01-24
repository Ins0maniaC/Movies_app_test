require "rails_helper"

RSpec.describe "Users", :type => :request do
  before(:each) do
    objects = RequestsHelper.prepare_requests()
    @user = objects[:user]
  end

  it "receives list of users" do
    get "/users", headers: {'Accept' => 'application/json'}
    expect(response).to have_http_status(200)
  end

  it "receives a particular user" do
    get "/users/#{@user.id}", headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(json['id']).to eq(@user.id)
    expect(json['index']).to eq(@user.index)
    expect(json['name']).to eq(@user.name)
    expect(response).to have_http_status(200)
  end

  it "creates a users" do
    post "/users", params:
    {
      user: {
        name: 'Alfred',
        index: '654321',
        password: 'password123'
      }
    }, headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(response).to have_http_status(201)
    expect(json['name']).to eq('Alfred')
    expect(json['index']).to eq('654321')
  end

  it "updates a user" do
    patch "/users/#{@user.id}", params:
    {
      user: {
        name: 'Henryk',
        password: 'password123'
      }
    }, headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(response).to have_http_status(200)
    expect(@user.name).not_to eq(json['name'])
    @user.reload
    expect(@user.name).to eq(json['name'])
    expect(json['name']).to eq('Henryk')

  end

  it "deletes a user" do
    expect(User.exists?(@user.id)).to eq(true)
    delete "/users/#{@user.id}", headers:
    {
      'Accept' => 'application/json'
    }

    expect(response).to have_http_status(204)
    expect(User.exists?(@user.id)).to eq(false)
  end
end
