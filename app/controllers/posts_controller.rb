class PostsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :require_token, only: [:create]
  swagger_controller :posts, 'Posts'


  # GET /posts/1
  # GET /posts/1.json
   swagger_api :show do
    summary 'Returns one post'
    param :path, :movie_id, :integer, :required, "Movie id"
    param :path, :topic_id, :integer, :required, "Topic id"
    param :path, :id, :integer, :required, "Post id"
    notes 'Notes...'
end
  def show
  end

  # GET /posts/new
  def new
    @movie = Movie.find(params[:movie_id])
	@topic = Topic.find(params[:topic_id])
	@post = @topic.posts.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  swagger_api :create do
    summary "Create new post"
    param :header, "Authorization", :string, :required, "Authentication token"
    param :path, :movie_id, :integer, :required, "Movie id"
    param :path, :topic_id, :integer, :required, "Topic id"
    param :form, "post[body]", :string, :required, "Body of a post"
end
  def create
    @movie = Movie.find(params[:movie_id])
	@topic = Topic.find(params[:topic_id])
	@post = @topic.posts.new(post_params)
	@post.user = current_user

    respond_to do |format|
      if @post.save
        format.html { redirect_to [@movie, @topic], notice: 'Post was successfully created.' }
		format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  swagger_api :update do
    summary "Update a post"
    param :path, :id, :integer, :required, "Post id"
    param :path, :topic_id, :integer, :required, "Topic id"
    param :path, :movie_id, :integer, :required, "Movie id"
    param :form, "post[body]", :string, :required, "Body of a post"
end
  def update
    respond_to do |format|
	  if @post.update(topic_params)
        format.html { redirect_to [@movie, @topic], notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  swagger_api :destroy do |post|
    summary 'Destroys a post'
    param :path, :id, :integer, :required, "Post id"
    param :path, :topic_id, :integer, :required, "Topic id"
    param :path, :movie_id, :integer, :required, "Movie id"
    notes 'Notes...'
end
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @movie = Movie.find(params[:movie_id])
	  @topic = Topic.find(params[:topic_id])
	  @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:body, :user_id, :topic_id)
    end
end
