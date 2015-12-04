class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = params[:name].nil? ? Post.all : filter(params[:name])
    @posts = @posts.sort_by(&:updated_at).reverse
    @tags = Tag.all.sort_by { |a| a.posts.count }.reverse
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    assign_tags(post_params[:tags_string])

    respond_to do |format|
      if @post.save
        format.html { redirect_to root_path, notice: 'Post was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    update_tags(post_params[:tags_string])

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to root_path, notice: 'Post was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    tags = Tag.all.select { |t| t.posts.count == 0 }
    tags.each(&:destroy)
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # gets object of tag with tag_string name
  def get_tag(tag_string)
    Tag.all.select { |tag| tag["name"] == tag_string }[0] unless Tag.all.empty?
  end

  # assing tags to new post
  def assign_tags(tags_string)
    tags_string.split(/\W+/).each do |t|
      @tag = get_tag(t)
      @tag = Tag.new(name: t) if @tag.nil?
      @post.tags << @tag
    end
  end

  # update tag of post
  def update_tags(tags_string)
    new_tags = []
    tags_string.split(/\W+/).each do |t|
      @tag = get_tag(t)
      @tag = Tag.new(name: t) if @tag.nil?
      @post.tags << @tag unless @post.tags.include? @tag
      new_tags << @tag
    end
    delete_tags(new_tags)
  end

  # delete unused tags when post is updated
  def delete_tags(new_tags)
    @post.tags.each { |t| @post.tags.delete(t) unless new_tags.include? t }
    Tag.all.select { |t| t.posts.count == 0 }.each(&:destroy)
  end

  # filter posts by tag name
  def filter(name)
    tag = Tag.all.select { |t| t["name"] == name }[0]
    Post.all.select { |post| post.tags.include? tag }
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:autor, :title, :body, :tags_string)
  end
end
