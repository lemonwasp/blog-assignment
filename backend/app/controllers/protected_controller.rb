class ProtectedController < ApplicationController
  before_action :authenticate_request  # JWT認証が必要

  def index
    render json: { message: "認証されたユーザーのみアクセス可能" }
  end
end