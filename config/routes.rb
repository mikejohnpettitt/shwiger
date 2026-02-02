Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ]
  root to: "pages#home"
  get "/demo", to: "pages#demo"
  get "/listen", to: "pages#listen"
  resources :decks do
    get :next, on: :member
  end

  resources :user_cards
  resources :user_decks
  resources :user_entry_similarities
  resources :study_sessions do
    get :next, on: :member
    get :results, on: :member
    get :end_session, on: :member
  end
  resources :tts_clips, only: [ :create, :show ]
end
