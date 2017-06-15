class UserPostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    search = params[:post_search].present? ? params[:post_search] : nil
    @posts = if search
               Post.search(search)
    else
      Post.all
    end
    respond_to do |format|
      format.js
    end
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      flash[:success] = t ".success"
      redirect_to user_post_path @post
    else
      flash[:danger] = t ".fail"
      render :new
    end
  end

  def show
    @post = Post.find_by id: params[:id]
    unless @post
      flash[:danger] = t ".not_found"
      redirect_to user_path current_user
    end
  end

  def edit
  end

  def update
    if @post.update_attributes post_params
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to user_post_path @post
  end

  def destroy
    if @post.destroy
      flash[:success] = t ".success"
      list_post
      respond_to do |format|
        format.js
      end
    else
      flash[:danger] = t ".fail"
      redirect_to user_post_path @post
    end
  end

  private

  def post_params
    params.require(:post).permit :title, :content, :image
  end

  def correct_user
    @post = current_user.posts.find_by id: params[:id]
    unless @post
      flash[:danger] = t ".not_found"
      redirect_to user_path current_user
    end
  end

  def list_post
    @posts = current_user.posts.newest.page(params[:page])
      .per Settings.post.per_page
  end
end
