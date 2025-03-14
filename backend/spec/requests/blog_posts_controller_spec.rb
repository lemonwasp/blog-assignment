require 'rails_helper'

RSpec.describe "BlogPosts API", type: :request do
  let(:user) { User.create(email: "test@example.com", password: "password") }
  let(:category) { Category.create(name: "テストカテゴリ") }
  let!(:blog_post) { BlogPost.create(title: "テストタイトル", content: "テスト内容", user: user, category: category) }

  let(:valid_headers) { { "Authorization" => "Bearer #{JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base, 'HS256') }" } }

  describe "GET /blog-posts" do
    it "すべてのブログ投稿を取得する" do
      BlogPost.create(title: "テストタイトル", content: "テスト内容", user: user, category: category)

      get "/blog-posts", headers: valid_headers
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body).size).to be >= 1
    end
  end

  describe "GET /blog-posts/:id" do
    it "特定のブログ投稿を取得する" do
      get "/blog-posts/#{blog_post.id}"
      expect(response).to have_http_status(200)
      expect(response.body).to include("テストタイトル")
    end
  end

  describe "POST /blog-posts" do
    it "新しいブログ投稿を作成する" do
      post_params = { title: "新しい投稿", content: "新しい内容", category_id: category.id }.to_json

      post "/blog-posts", params: post_params, headers: valid_headers.merge("CONTENT_TYPE" => "application/json")
      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)["title"]).to eq("新しい投稿")
    end
  end

  describe "DELETE /blog-posts/:id" do
    it "ブログの投稿を削除する" do
      delete "/blog-posts/#{blog_post.id}", headers: valid_headers

      expect(response).to have_http_status(200) 
      expect(JSON.parse(response.body)["message"]).to eq("ブログの投稿が削除されました。") 
      expect(BlogPost.find_by(id: blog_post.id)).to be_nil  
    end
  end
end
