Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  apipie
  ActiveAdmin.routes(self)

  root to: 'home#index'
  devise_for :users, controllers: { confirmations: "confirmations", omniauth_callbacks: 'omniauth_callbacks' }

  resources :users do
    post 'upload_photo', on: :collection
  end

  resources :shows do
    get 'payment', on: :member
  end
  resources :pictures do
    post 'destroy', on: :member, as: 'destroy'
  end

  namespace :api do
    namespace :v1 do
      resources :users, :defaults => { :format => 'json' } do
        get 'search', on: :collection
        post 'pictures', on: :collection
        get 'list/pictures', to: 'users#list_pictures', on: :collection
        delete 'picture', to: 'users#destroy_pictures', on: :collection
        get 'artist', on: :collection
        post 'profile_picture', to: 'users#profile_picture', on: :collection
        delete 'disconnect-stripe', to: 'users#disconnect_stripe', on: :collection
      end
      resources :shows, :defaults => { :format => 'json' } do
        post 'toggle_active', on: :member
        get 'arts', on: :collection
        get 'search', on: :collection
      end
      resources :pictures, :defaults => { :format => 'json' }
      resources :bookings, :defaults => { :format => 'json' } do
        post 'change_status', on: :member
        post 'apply_coupon'
      end
      resources :arts, :defaults => { :format => 'json' }
      resources :showcases
      resources :user_availabilities, path: :availabilities, only: [:index, :show, :create, :destroy]
      resources :credit_cards, only: [:create] do
        patch 'make_default', on: :member
      end
    end
  end

  get '/dashboard', to: 'dashboard#index'
  get '/dashboard/profile', to: 'dashboard#profile', as: 'profile_dashboard'
  get '/dashboard/messages', to: 'dashboard#messages', as: 'messages_dashboard'
  get '/dashboard/shows', to: 'dashboard#shows', as: 'shows_dashboard'
  get '/dashboard/performances', to: 'dashboard#performances', as: 'performances_dashboard'
  get '/dashboard/account', to: 'dashboard#account', as: 'account_dashboard'
  patch '/dashboard/update', to: 'dashboard#update', as: 'update_dashboard'
  get '/dashboard/bookings', to: 'dashboard#bookings', as: 'bookings_dashboard'
  post '/contact', to: 'home#contact', as: 'home_contact'
  post '/society', to: 'home#society', as: 'home_society'

end
