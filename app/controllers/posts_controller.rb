#encoding: utf-8
class PostsController < ApplicationController

  before_filter :authenticate_user!,  :only => [:edit, :create, :update, :destroy]
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    if !is_owner?(@post)
      redirect_to root_path, :notice=>"抱歉，您没有编辑的权限！"
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(:title=>params[:post][:title], :user_id=>current_user.id, :description=>params[:post][:description])

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update

    @post = Post.find(params[:id])
    
    respond_to do |format|
      if is_owner?(@post) && @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    if is_owner?(@post)
      @post.destroy

      respond_to do |format|
        format.html { redirect_to posts_url }
        format.json { head :no_content }
      end

    else
      respond_to do |format|
        format.html { redirect_to posts_url, :notice=>"抱歉，您没有编辑的权限！" }
        format.json { head :no_content }
      end
    end
    
  end
end

private
  def is_owner?(post)
    (current_user && current_user.id == post.user.id)
  end