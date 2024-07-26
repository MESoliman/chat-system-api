Rails.application.routes.draw do
  resources :applications, param: :token, only: [:create, :update, :index, :show] do
    resources :chats, param: :number, only: [:create, :update, :index, :show] do
      resources :messages, param: :number, only: [:create, :update, :index, :show] do
        get 'search', on: :collection
      end  
    end
  end
end
