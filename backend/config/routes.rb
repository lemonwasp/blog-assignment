Rails.application.routes.draw do
  # 블로그 관련 API
  resources :blog_posts, path: "blog-posts"
  resources :categories
  resources :tags

  # ユーザー認証API
  resources :users, only: [:create]  # 会員登録API
  post "/login", to: "sessions#create"  # ログインAPI
  get "/protected-route", to: "protected#index"  # 認証が必要なAPIを追加
  delete "/logout", to: "sessions#destroy"  # ログアウトAPI
end