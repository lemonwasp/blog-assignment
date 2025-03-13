class Tag < ApplicationRecord
  has_and_belongs_to_many :blog_posts  # 多対多(N:M)関係設定
end