class BlogPostsController < ApplicationController
  before_action :authenticate_request, only: [:create, :update, :destroy]  
  before_action :set_blog_post, only: [:show, :update, :destroy] 

  def index
    blog_posts = BlogPost.includes(:user, :category, :tags)
  
    if params[:search].present?
      blog_posts = blog_posts.where("LOWER(title) LIKE LOWER(?) OR LOWER(content) LIKE LOWER(?)", "%#{params[:search]}%", "%#{params[:search]}%")
    end
  
    if params[:category].present?
      blog_posts = blog_posts.where(category_id: params[:category])
    end
  
    render json: blog_posts.as_json(include: [:user, :category, :tags]) 
  end

  def show
    if @blog_post
      render json: @blog_post.as_json(include: { user: { only: [:email] }, category: {}, tags: {} })
    else
      render json: { error: "該当する投稿が存在しません。" }, status: :not_found
    end
  end

  def create
    post = BlogPost.new(
      title: params[:title],
      content: params[:content],
      category_id: params[:category_id].present? ? params[:category_id] : nil,
      user_id: @current_user.id
    )
  
    if post.save
      if params[:tags].present?
        tag_ids = params[:tags].map(&:to_i)
        post.tags = Tag.where(id: tag_ids)
      end
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    Rails.logger.debug "アップデート要求データ: #{params.inspect}" 

    if @blog_post.nil?
      render json: { error: "該当する投稿が存在しません。" }, status: :not_found
      return
    end

    if @blog_post.update(blog_post_params)
      if params[:tags].present?
        Rails.logger.debug "タグアップデート: #{params[:tags]}" 
        tag_ids = params[:tags].is_a?(Array) ? params[:tags] : params[:tags].split(",") 
        tags = Tag.where(id: tag_ids.map(&:to_i))
        @blog_post.tags = tags
      end
      render json: @blog_post, include: [:category, :tags]
    else
      render json: @blog_post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @blog_post.nil?
      render json: { error: "該当する投稿が存在しません。" }, status: :not_found
      return
    end

    if @blog_post.user_id == @current_user.id
      @blog_post.destroy
      render json: { message: "ブログの投稿が削除されました。" }
    else
      render json: { error: "削除権限がありません。" }, status: :forbidden
    end
  end

  private

  def set_blog_post
    @blog_post = BlogPost.find_by(id: params[:id])
  end

  def blog_post_params
    params.require(:blog_post).permit(:title, :content, :category_id, tag_ids: [])
  end
end
