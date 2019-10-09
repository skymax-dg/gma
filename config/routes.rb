Gma::Application.routes.draw do

  resources :key_words do 
    member do
      get 'manage_key_word_rels'
      get 'change_n_order'
    end
  end

  resources :events

  root :to => "menu#home"

  get "menu/contact"

  get "menu/help"

  match '/signout', :to => 'sessions#destroy'

  resources :sessions, :only => [:new, :create, :destroy]
  
  resources :users

  resources :confs

  resources :localitas do
    collection do
      get :filter
    end
  end

  resources :paeses

  resources :ivas

  resources :causmags

  resources :causales

  resources :agentes

  resources :contos do
    collection do
      get :filter
      get :anagen_exit
    end
  end

  resources :scadenzas do
    collection do
      get :filter
    end
  end

  resources :costos
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
      get :filter
      get :filter_mov_vend_all
      get :stp_mov_vend_all
      get :filter_mov_vend_all_xls
      get :mov_vend_all_xls
      get :set_distrib
    end
  end

  resources :anagens do
    collection do
      get :filter
      get :chg_tipo
      get :change_article
      get :change_event
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
      get :set_causmags
      get :set_provv
      get :addtesrigdoc_fromxls
      get :genera_xls_articoli
      get :import_by_xml
      post :create_by_xml
    end
    member do
      get :add1row4article
      get :giacyearprec
      get :delrowqta0
      get :stp
      get :dati_ind
      get :stp_ind
      get :ges_datisped
      get :ges_costo
      get :ges_datiscad
      post :addrow_fromxls
      get :upload_xls
    end
  end

  resources :rigdocs do
    collection do
      get :art_cod_exit
      get :art_des_exit
      get :art_sconto_exit
    end
    member do
      get :up
      get :down
    end
  end

	post 'authenticate',  to: 'authentication#authenticate'
  get 'authors',        to: 'anagens#authors'
  get 'teachers',       to: 'anagens#teachers'
  get 'events',         to: 'articles#events'
  get 'categories',     to: 'key_words#categories'
  get 'products',       to: 'articles#products'
  get 'announcements',  to: 'articles#announcements'
  get 'promotions',     to: 'articles#promotions'
  get 'bestsellers',    to: 'articles#bestsellers'
  get 'products',       to: 'articles#products'
  get 'products_query', to: 'articles#products_query'
  get 'anagens_query',  to: 'anagens#anagens_query'
  get 'users_query',    to: 'users#users_query'
  post 'users_query',   to: 'users#users_query'
  get 'get_localitas',  to: 'localitas#localitas_query'
      

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
