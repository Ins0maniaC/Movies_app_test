class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  skip_before_action	:verify_authenticity_token
  before_action :require_token, only: [:create]
  swagger_controller	:topics,	'Topics'


  # GET /topics/1
  # GET /topics/1.json
  swagger_api :show do
    summary 'Returns one topic'
    param :path, :movie_id, :integer, :required, "Movie id"
    param :path, :id, :integer, :required, "Topic id"
    notes 'Notes...'
end
  def show
  end

  # GET /topics/new
  def new
	@movie = Movie.find(params[:movie_id])
	@topic = @movie.topics.new
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  swagger_api :create do
    summary "Create new topic"
    param :header, "Authorization", :string, :required, "Authentication token"
    param :path, :movie_id, :integer, :required, "Movie id"
    param :form, "topic[title]", :string, :required, "Title of a topic"
end
  def create
    @movie = Movie.find(params[:movie_id])
	@topic = @movie.topics.new(topic_params)
    @topic.user = current_user

    respond_to do |format|
      if @topic.save
        format.html { redirect_to [@movie, @topic], notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  swagger_api :update do
    summary "Update a topic"
    param :path, :id, :integer, :required, "Topic id"
    param :path, :movie_id, :integer, :required, "Movie id"
    param :form, "topic[title]", :string, :required, "Topic title"
end
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to [@movie, @topic], notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  swagger_api :destroy do
    summary 'Destroys a topic'
    param :path, :id, :integer, :required, "Topic id"
    param :path, :movie_id, :integer, :required, "Movie id"
    notes 'Notes...'
end
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @movie = Movie.find(params[:movie_id])
	  @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title, :user, :movie_id)
    end
end
