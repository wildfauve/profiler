Rails.application.routes.draw do
  root 'id_attributes#index'

  resources :id_attributes
  
  resources :configurations
  
  resources :green_kiwis
  
  resources :profiles
  
  resources :concepts do
    resources :refs
  end
  
  resources :identities, only: [:index] do
    collection do
      get 'sign_up'
      get 'login'
      get 'authorisation'
      put 'logout'
    end
  end

  

end
