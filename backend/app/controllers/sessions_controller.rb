# ログイン/ログアウト API
# ログイン時にメール+パスワードを確認してからsession[:user_id]に保存
# ログアウト時のsession[:user_id] = nilで初期化
class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  # ログイン(JWTトークン発行)
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      token = encode_token({ user_id: user.id })  # JWTトークン発行
      render json: { message: "ログイン成功", user: user, token: token }
    else
      render json: { error: "メールアドレスまたはパスワードが正しくありません。" }, status: :unauthorized
    end
  end

  # ログアウト（クライアントがJWTを削除する）
  def destroy
    render json: { message: "ログアウト完了" }
  end
end

