class MoviesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_movie, only: [:show, :edit, :update, :destroy, :follow, :unfollow]
  before_action :require_token, only: [:follow, :unfollow]
  swagger_controller :movies, 'Movies'

  swagger_api :follow do
    summary 'Follows a Movie'
    notes 'Notes...'
    param :header, "Authorization", :string, :required, "Authentication token"
    param :path, :id, :integer, :required, "Movie id"
end
  def follow
    unless current_user.follows?(@movie)
      current_user.movies.append(@movie)
    end
    redirect_to @movie
  end

  swagger_api :unfollow do
    summary 'Unfollows a Movie'
    notes 'Notes...'
    param :header, "Authorization", :string, :required, "Authentication token"
    param :path, :id, :integer, :required, "Movie id"
end
  def unfollow
    if current_user.follows?(@movie)
      @movie.users.delete(current_user)
    end
    redirect_to @movie
  end
  
  # GET /movies
  # GET /movies.json
   swagger_api :index do
    summary 'Returns all Movies'
    notes 'Notes...'
end
  def index
    @movies = Movie.all
  end

  # GET /movies/1
  # GET /movies/1.json
  swagger_api :show do
    summary 'Returns one movie'
    param :path, :id, :integer, :required, "Movie id"
    notes 'Notes...'
end
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies
  # POST /movies.json
  swagger_api :create do
    summary "Create a movie"
    param :form, "movie[name]", :string, :required, "Movie name"
end
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: 'Movie was successfully created.' }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1
  # PATCH/PUT /movies/1.json
   swagger_api :update do
    summary "Update a movie"
    param :path, :id, :integer, :required, "Course id"
    param :form, "movie[name]", :string, :required, "Movie name"
end
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: 'Movie was successfully updated.' }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.json
  swagger_api :destroy do
    summary 'Destroys a movie'
    param :path, :id, :integer, :required, "Movie id"
    notes 'Notes...'
end
  def destroy
    @movie.destroy
    respond_to do |format|
      format.html { redirect_to movies_url, notice: 'Movie was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:movie).permit(:name)
    end
end
