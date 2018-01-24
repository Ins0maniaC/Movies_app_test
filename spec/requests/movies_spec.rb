require "rails_helper"

RSpec.describe "Movies", :type => :request do
  before(:each) do
    objects = RequestsHelper.prepare_requests()
    @user = objects[:user]
    @movie = objects[:movie]
  end

  it "receives list of movies" do
    get "/movies", headers: {'Accept' => 'application/json'}
    expect(response).to have_http_status(200)
  end

  it "receives a particular movie" do
    get "/movies/#{@movie.id}", headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(json['id']).to eq(@movie.id)
    expect(json['name']).to eq(@movie.name)
    expect(response).to have_http_status(200)
  end

  it "follows a movie" do
    expect(@movie.users.exists?(@user.id)).to eq(false)
    get "/movies/#{@movie.id}/follow", headers: {
      'Authorization' => "Token #{@user.token}",
      'Accept' => 'application/json'
    }
    expect(@movie.users.exists?(@user.id)).to eq(true)
  end

  it "unfollows a movie" do
    @movie.users.append(@user)

    expect(@movie.users.exists?(@user.id)).to eq(true)

    get "/movies/#{@movie.id}/unfollow", headers: {
      'Authorization' => "Token #{@user.token}",
      'Accept' => 'application/json'
    }

    expect(@movie.users.exists?(@user.id)).to eq(false)
  end

  it "creates a movie" do
    post "/movies", params:
    {
      movie: {
        name: 'New name',
      }
    }, headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(response).to have_http_status(201)
    expect(json['name']).to eq('New name')
  end

  it "updates a movie" do
    patch "/movies/#{@movie.id}", params:
    {
      movie: {
        name: 'Another name'
      }
    }, headers: {'Accept' => 'application/json'}

    json = JSON(response.body)

    expect(response).to have_http_status(200)
    expect(@movie.name).not_to eq(json['name'])
    @movie.reload
    expect(@movie.name).to eq(json['name'])
    expect(json['name']).to eq('Another name')

  end

  it "deletes a movie" do
    expect(Movie.exists?(@movie.id)).to eq(true)
    delete "/movies/#{@movie.id}", headers:
    {
      'Accept' => 'application/json'
    }

    expect(response).to have_http_status(204)
    expect(Movie.exists?(@movie.id)).to eq(false)
  end
end
