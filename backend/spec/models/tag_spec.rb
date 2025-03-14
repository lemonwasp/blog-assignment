RSpec.describe Tag, type: :model do
    it "タグがあれば有効だ" do
      tag = Tag.new(name: "Ruby")
      expect(tag).to be_valid
    end
  end