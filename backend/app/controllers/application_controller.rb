class ApplicationController < ActionController::API
  before_action :authenticate_request, except: [:index, :show]  # 読み取り(GET要請)は認証なしで可能

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base)  # Rails 5.2+ 方式
  end

  def decode_token
    header = request.headers['Authorization']
    return nil unless header.present?  # Authorization ヘッダーがなければ nil 返却

    token = header.split(' ')[1]  # 「Bearerトークン値」の形なので、2番目の値を抽出
    begin
      JWT.decode(token, Rails.application.credentials.secret_key_base, true, algorithm: 'HS256')[0]
    rescue JWT::DecodeError  # JWTデコーディング失敗処理
      nil
    end
  end

  def authenticate_request
    decoded_token = decode_token
    if decoded_token
      @current_user = User.find_by(id: decoded_token["user_id"])
      render json: { error: 'ユーザーが存在しません。' }, status: :unauthorized unless @current_user
    else
      render json: { error: 'ログインが必要です。' }, status: :unauthorized
    end
  end
end
