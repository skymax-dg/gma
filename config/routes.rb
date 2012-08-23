Gma::Application.routes.draw do

  root :to => "menu#home"

  get "menu/contact"

  get "menu/help"

  match '/signout', :to => 'sessions#destroy'

  resources :sessions, :only => [:new, :create, :destroy]
  
  resources :users

  resources :localitas do
    collection do
      get :filter
    end
  end

  resources :paeses

  resources :ivas

  resources :causmags

  resources :causales

  resources :contos do
    collection do
      get :filter
      get :anagen_exit
    end
  end

  resources :spedizs, :only => [:new, :create, :edit, :update, :destroy]  do
    collection do
      get :setind
    end
  end

  resources :articles do
    member do
      get :filter_mov_vend
      get :stp_mov_vend
      get :filter_mov_vend_xls
      get :mov_vend_xls
    end
    collection do
      get :filter_mov_vend_all
      get :stp_mov_vend_all
      get :filter_mov_vend_all_xls
      get :mov_vend_all_xls
    end
  end

  resources :anagens do
    collection do
      get :filter
      get :chg_tipo
    end
  end

  resources :anainds do
    collection do
      get :descrizloc
      get :reset_locid
    end
  end

  resources :tesdocs do
    collection do
      get :filter
      get :addtesrigdoc_fromxls
    end
    member do
      get :add1row4article
      get :delrowqta0
      get :stp
      get :ges_datisped
      post :addrow_fromxls
      get :upload_xls
    end
  end

  resources :rigdocs do
    collection do
      get :article_exit
    end
    member do
      get :up
      get :down
    end
  end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
