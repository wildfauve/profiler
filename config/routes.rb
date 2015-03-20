Rails.application.routes.draw do
  root 'id_attributes#index'

  resources :id_attributes
  
  resources :configurations
  
  resources :green_kiwis
  
  resources :concepts do
    resources :refs
  end
  

end
