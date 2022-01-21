Rails.application.routes.draw do
  config = Rails.application.config.system_service
  constraints host: config[:admin][:host] do
    namespace :admin do
      root 'top#index'
      get 'login', to: 'sessions#new'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      resources :staff do
        resources :staff_events, only: %i[index]
      end
    end
  end
  constraints host: config[:staff][:host] do
    namespace :staff do
      root 'top#dashboard'
      get 'login', to: 'sessions#new'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      resource :account do
        patch :confirm
      end
      resource :password, only: %i[show update edit]
      resources :customers
      resources :programs do
        resources :entries, only: [] do
          patch :update_all, on: :collection
        end
      end
      get 'message/count', to: 'ajax#message_count'
      resources :messages, only: %i[index show destroy] do
        get :inbound, :outbound, on: :collection
        patch :all_read, on: :collection
        patch :inbound_all_read, on: :collection
        patch :outbound_all_read, on: :collection
        resource :reply, only: %i[new create] do
          post :confirm
        end
      end
      resources :box_garbages do
        delete :all_destroy, on: :collection
      end
    end
    namespace :test do
      root 'top#dashboard'
    end
  end
  constraints host: config[:customer][:host] do
    namespace :customer do
      root 'top#index'
      get 'login', to: 'sessions#new'
      post 'login', to: 'sessions#create'
      delete 'logout', to: 'sessions#destroy'
      resources :programs, only: %i[index show] do
        resource :entry, only: %i[create] do
          patch :cancel
        end
      end
      resource :account, except: %i[new create destroy] do
        patch :confirm
      end
      get 'message/count', to: 'ajax#message_count'
      resources :messages, only: %i[index new create show destroy] do
        get :inbound, :outbound, on: :collection
        patch :all_read, on: :collection
        patch :inbound_all_read, on: :collection
        patch :outbound_all_read, on: :collection
        post :confirm, on: :collection
        resource :reply, only: %i[new create] do
          post :confirm
        end
      end
      resources :box_garbages,only: %i[index destroy] do
        delete :all_destroy, on: :collection
      end
    end
  end
end
