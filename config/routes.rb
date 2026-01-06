Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ]
  root to: "pages#home"
  resources :decks do
    get :next, on: :member
  end
  resources :user_cards
  resources :user_decks
  resources :study_sessions do
    get :next, on: :member
    get :results, on: :member
    get :end_session, on: :member
  end
end
