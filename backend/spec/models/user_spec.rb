require 'rails_helper'

RSpec.describe User, type: :model do
  # 有効なユーザーが生成されるかどうかをテスト
  it "メールとパスワードがあれば有効だ" do
    user = User.new(email: "test@example.com", password: "password")
    expect(user).to be_valid
  end

  # メールがないときに無効であるかどうかをテストする
  it "メールがなければ有効ではない" do
    user = User.new(password: "password")
    expect(user).not_to be_valid
  end

  # パスワードがないときに有効でないかテスト
  it "パスワードがないと無効だ" do
    user = User.new(email: "test@example.com")
    expect(user).not_to be_valid
  end
end
