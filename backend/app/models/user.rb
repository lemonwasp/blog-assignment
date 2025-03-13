class User < ApplicationRecord
  self.primary_key = "id"  #  UUIDをプライマリキーに設定
  has_many :blog_posts

  has_secure_password  # パスワード暗号化
  validates :email, presence: true, uniqueness: true

  before_create :set_uuid

  private

  def set_uuid
    self.id ||= SecureRandom.uuid  # 新しいUserが生成される時にUUIDを自動生成
  end
end