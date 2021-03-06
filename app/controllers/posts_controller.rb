class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  layout 'welcome'
  # GET /posts
  def index
    if params[:post] != nil
      if params[:post][:search] then
        words = params[:post][:search].split(/[^[[:word:]]]+/)
        lst_of_pre = ['about', 'above', 'across', 'after', 'against', 'along', 'amid', 'among', 'around', 'as', 'at', 'before', 'behind', 'below', 'beneath', 'beside', 'between', 'but', 'by', 'down', 'during', 'except', 'for','from', 'in', 'into', 'near', 'like', 'of', 'off', 'on', 'over', 'out', 'through', 'to', 'toward', 'under', 'upon', 'versus', 'with', 'within', 'without']
        query = ""
        or1 = ""
        words.each do |word|
          if word.length > 3 && lst_of_pre.exclude?(word) then
            query += or1 + "title LIKE '%" + word + "%'"
            or1 = " OR "
          end
        end
        #@posts = Post.where("title LIKE '%" + params[:post][:search] + "%'")
        @posts = Post.where(query)
      else
        @posts = Post.all
      end
    else
      @posts = Post.all
    end 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  def show
    @comment = Comment.new
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    #if params[:post] == nil then
      #index
      #render :index
    #else
      @post = Post.new(post_params)

      if @post.save
        #index
        #render :index
        redirect_to action: "index", notice: 'Post was successfully created.'
        #redirect_to @posts, notice: 'Post was successfully created.'
      else
        render :new
      end
    #end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
