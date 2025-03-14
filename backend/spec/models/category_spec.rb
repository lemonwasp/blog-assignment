RSpec.describe Category, type: :model do
    it "カテゴリーがあれば有効だ" do
      category = Category.new(name: "プログラミング")
      expect(category).to be_valid
    end
  end