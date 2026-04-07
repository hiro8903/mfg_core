Rails.application.routes.draw do
  resources :material_requests do
    member do
      patch :submit
      patch :approve
      patch :reject # 'returned' status
    end
  end
  resources :users do
    member do
      patch :undiscard
    end
  end
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # [意図] ログイン成功後のリダイレクト先（root_url）を定義するため。
  #        現時点ではトップページが未作成のため、暫定的にヘルスチェックページを使用。
  #        Step 3（マスタ管理）完成後に適切なダッシュボードへ変更する。
  # [意味] `root "controller#action"` でアプリケーションの「/」へのアクセス先を決める。
  root "rails/health#show"
end
