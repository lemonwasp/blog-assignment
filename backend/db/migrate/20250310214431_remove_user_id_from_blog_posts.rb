class RemoveUserIdFromBlogPosts < ActiveRecord::Migration[6.0]
  def change
    remove_column :blog_posts, :user_id
  end
end
