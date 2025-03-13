class TagsController < ApplicationController
  def index
    tags = Tag.all
    render json: tags
  end

  def show
    tag = Tag.find(params[:id])
    render json: tag
  end

  def create
    tag = Tag.new(tag_params)
    if tag.save
      render json: tag, status: :created
    else
      render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @blog_post.update(blog_post_params)
      if params[:tags].present?
        tag_ids = params[:tags].is_a?(Array) ? params[:tags] : params[:tags].split(",") 
        tags = Tag.where(id: tag_ids.map(&:to_i)) # 문文字列の場合、整数に変換して照会
        @blog_post.tags = tags
      end
      render json: @blog_post, include: [:category, :tags]
    else
      render json: @blog_post.errors, status: :unprocessable_entity
    end
  end
  

  def destroy
    tag = Tag.find(params[:id])
    tag.destroy
    render json: { message: "Tag deleted successfully" }
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end
end
