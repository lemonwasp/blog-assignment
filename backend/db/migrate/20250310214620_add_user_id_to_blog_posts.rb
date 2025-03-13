class AddUserIdToBlogPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :blog_posts, :user_id, :string, foreign_key: true
  end
end
