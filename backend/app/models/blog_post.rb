class BlogPost < ApplicationRecord
  belongs_to :user, optional: true  # ブログの投稿はuserを持つこともできるし、持たないこともできる
  belongs_to :category, optional: true  # ブログの記事はカテゴリーを持つこともあればないこともある
  has_and_belongs_to_many :tags  # 多対多(N:M)関係設定

  before_create :set_uuid  # user_id自動生成

  private

  def set_uuid
    self.user_id ||= SecureRandom.uuid  # user_idがなければ自動生成
  end
end
