require "rails_helper"

RSpec.describe "Topics", :type => :request do
  before(:each) do
    objects = RequestsHelper.prepare_requests()
    @user = objects[:user]
    @movie = objects[:movie]
    @topic = objects[:topic]
  end

  it "receives a particular topic" do
    get "/movies/#{@movie.id}/topics/#{@topic.id}", headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(json['id']).to eq(@topic.id)
    expect(json['title']).to eq(@topic.title)
    expect(json['user_id']).to eq(@user.id)
    expect(json['movie_id']).to eq(@movie.id)
    expect(response).to have_http_status(200)
  end

  it "creates a topic" do
    post "/movies/#{@movie.id}/topics", params:
    {
      topic: {
        title: 'A whole new topic'
      }
    }, headers: {
      'Accept' => 'application/json',
      'Authorization' => "Token #{@user.token}"
    }

    json = JSON(response.body)

    expect(response).to have_http_status(201)
    expect(json['title']).to eq('A whole new topic')
    expect(json['user_id']).to eq(@user.id)
    expect(json['movie_id']).to eq(@movie.id)
  end

  it "updates a topic" do
    patch "/movies/#{@movie.id}/topics/#{@topic.id}", params:
    {
      topic: {
        title: 'Changed title'
      }
    }, headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(response).to have_http_status(200)
    expect(@topic.title).not_to eq(json['title'])
    @topic.reload
    expect(@topic.title).to eq(json['title'])
    expect(json['title']).to eq('Changed title')

  end

  it "deletes a topic" do
    expect(Topic.exists?(@topic.id)).to eq(true)
    delete "/movies/#{@movie.id}/topics/#{@topic.id}", headers:
    {
      'Accept' => 'application/json'
    }

    expect(response).to have_http_status(204)
    expect(Topic.exists?(@topic.id)).to eq(false)
  end
end
