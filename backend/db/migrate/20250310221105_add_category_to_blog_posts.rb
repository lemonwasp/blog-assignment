class AddCategoryToBlogPosts < ActiveRecord::Migration[6.1]
  def change
    add_reference :blog_posts, :category, foreign_key: true  # ✅ null: false 제거
  end
end