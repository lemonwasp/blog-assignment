# 会員登録API
# ユーザーがメール+パスワードを入力すると、Userモデルに保存
# パスワードはhas_secure_passwordで自動ハッシュ
# 成功時にユーザー情報を返却 / 失敗時にエラーメッセージを返却
class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    Rails.logger.debug "🔍 Received params: #{params.inspect}" 
    puts "✅ UsersController#create 実行!" # 実行確認ログ
    puts "📩 伝達されたパラメータ: #{params.inspect}" # パラメータ確認

    user = User.new(user_params)
    if user.save
      puts "✅ ユーザー保存成功: #{user.inspect}"
      render json: { message: '会員登録成功!', user: user }, status: :created
    else
      puts "❌ ユーザー保存失敗: #{user.errors.full_messages}"
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end