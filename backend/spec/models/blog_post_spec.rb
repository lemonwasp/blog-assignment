RSpec.describe BlogPost, type: :model do
    it "タイトルと内容があれば有効だ" do
      post = BlogPost.new(title: "テストタイトル", content: "テスト内容", user_id: 1, category_id: 1)
      expect(post).to be_valid
    end
  
    it "タイトルがなければ有効ではない" do
      post = BlogPost.new(content: "テスト内容", user_id: 1, category_id: 1)
      expect(post).not_to be_valid
    end
  
    it "内容がなければ有効ではない" do
      post = BlogPost.new(title: "テストタイトル", user_id: 1, category_id: 1)
      expect(post).not_to be_valid
    end
  
    it "カテゴリーなしでも有効だ" do
      post = BlogPost.new(title: "テストタイトル", content: "テスト内容", user_id: 1, category_id: nil)
      expect(post).to be_valid
    end
  
    it "タグなしでも有効だ" do
      post = BlogPost.new(title: "テストタイトル", content: "テスト内容", user_id: 1, category_id: 1, tags: [])
      expect(post).to be_valid
    end
  end
  