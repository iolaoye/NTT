NTTG3::Application.routes.draw do
  #resources :ways
  #resources :weathers
  #resources :stations
  #resources :counties
  #resources :states
  resources :locations
  resources :projects
  resource :session
  #resources :users
  resources :welcomes

  resources :users do
	  resources :projects do
		  resources :locations do
			  resources :fields do
				 resources :soils do 
					resources :layers
				 end
				 resources :weathers do
					resources :ways
				 end
			  end
		  end
	  end
  end
  
  resources :weathers do
	member do
		post 'save_coordinates'
	end
  end

  resources :states do
    resources :counties
  end

  #resources :soils do
    #get 'index', on: :member
  #end

  #resources :projects do
    #member do
      #get 'shows'
	#end 
  #end 
	
  resources :locations do
    get :send_to_mapping_site, on: :member
    post :receive_from_mapping_site, on: :member
  end

  #define two name routes, login_path and logout_path
  get '/login' => "sessions#index", :as => "login"
  get '/logout' => "sessions#destroy", :as => "logout"

  get 'sessions/create'
  get 'sessions/destroy'
  get 'users/new'

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
