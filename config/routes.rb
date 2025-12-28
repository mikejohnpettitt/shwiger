Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :decks do
    get :next, on: :member
  end
  resources :user_decks
  resources :study_sessions do
    get :next, on: :member
  end
end
