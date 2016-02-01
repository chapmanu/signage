Rails.application.routes.draw do
  
  get 'cascade/form'
  post 'cascade/import'

  get 'notifications/index'

  controller :marketing do
    get :home
  end

  # Devise
  devise_for :users

  # Admin
  get 'admin', to: 'admin#index'
  get 'admin/index'
  get 'admin/emergency'
  get 'admin/devices'
  get 'admin/sessions'
  post 'admin/update_emergency'
  post 'admin/clear_emergency'


  concern :ownable do
    post   'add_owner',    on: :member
    delete 'remove_owner', on: :member
    get    'autocomplete_user_email', on: :collection
  end

  # Signs
  resources :signs, concerns: :ownable do
    get    'play',         on: :member
    get    'poll',         on: :member
    post   'order',        on: :member
    delete 'remove_slide', on: :member
  end

  # Slides
  patch 'slides/live_preview'
  post 'slides/live_preview'
  resources :slides, concerns: :ownable do
    get   'preview', on: :member
    get   'draft', on: :member
    patch 'draft', on: :member
  end

  # Sign Slide
  resources :sign_slides, only: [] do
    post   'approve', on: :member
    delete 'reject',  on: :member
  end


  # Users
  resources :users do
    get 'lookup', on: :collection
  end

  root 'notifications#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
