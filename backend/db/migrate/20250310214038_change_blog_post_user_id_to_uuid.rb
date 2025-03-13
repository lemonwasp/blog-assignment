class ChangeBlogPostUserIdToUuid < ActiveRecord::Migration[6.0]
  def change
    remove_column :blog_posts, :user_id  # 既存ID削除
    add_column :blog_posts, :user_id, :string  # UUIDを保存するstringカラムを追加
  end
end
