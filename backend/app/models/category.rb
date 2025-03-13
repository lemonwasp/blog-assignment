class Category < ApplicationRecord
  has_many :blog_posts  # カテゴリは複数のブログ記事を持つことができる
end