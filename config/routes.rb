NTTG3::Application.routes.draw do
  resources :climates


  resources :watershed_scenarios
  resources :watersheds
  resources :people
  resources :charts
  resources :events
  resources :descriptions
  resources :apex_parameters
  resources :apex_controls
  resources :results
  resources :sites
  resources :modifications
  resources :soil_operations
  resources :subareas
  resources :parameters
  resources :controls
  resources :create_table_fertilizers
  resources :cropping_systems
  resources :fertilizer_types
  resources :simulations
  resources :fertilizers
  resources :animals
  resources :irrigations
  resources :bmpsublists
  resources :bmplists
  resources :tillages
  resources :activities
  resources :crops
  resources :bmps
  get "operations/list"
  resources :operations
  resources :scenarios
  #resources :ways
  #resources :weathers
  #resources :stations
  resources :counties
  #resources :states
  #resources :locations
  #resources :projects
  resource :session
  #resources :users
  resources :welcomes
  #resources :fields
  resources :apex_soils
  resources :apex_layers
  resources :results do
	get 'sel', on: :member
  end 
  resources :watershed_scenarios do
     post 'new_scenario', on: :member
  end
  resources :users do
	  resources :projects 
  end

  resources :projects do
	resources :locations
    get 'upload', on: :member
    get 'download', on: :member
    get :group, on: :member
  end
 
  resources :weathers do
	member do
		post 'save_coordinates'
	end
  end

  resources :states do
    resources :counties
	post :show_counties, on: :collection
  end

  resources :activities do
    resources :tillages
  end

  resources :fertilizer_types do
    resources :fertilizers
  end

  resources :locations do
    get :send_to_mapping_site, on: :member
    post :receive_from_mapping_site, on: :member
    get :location_fields, on: :member 
  end

  resources :fields do
    get :list, on: :member 
    resources :soils
    resources :scenarios
	resources :weathers
	get :field_soils, on: :member
	get :field_scenarios, on: :member
    get 'create_soils', on: :member
  end

  resources :watersheds do
	get :list, on: :member
  end

  resources :soils do
    get :list, on: :member
    resources :layers
	get :soil_layers, on: :member
  end

  resources :layers do
    get :list, on: :member
  end

  resources :scenarios do
    get :list, on: :member
	get :scenario_operations, on: :member
	get :scenario_bmps, on: :member
  end

  resources :operations do
	get :list, on: :member
	get :cropping_system, on: :member
    get 'download', on: :member
    get :open, on: :member
    get :upload_system, on: :member
  end

  resources :bmps do
	get :list, on: :member
  end

  resources :bmplists do
     resources :bmpsublists
  end

  #define two name routes, login_path and logout_path
  get '/login' => "sessions#index", :as => "login"
  get '/logout' => "sessions#destroy", :as => "logout"

  get 'sessions/create'
  get 'sessions/destroy'
  get 'users/new'
  post 'projects/upload_project'
  post 'weathers/upload_weather'
  root to: 'welcomes#index'
  
  get '/about' => "about#index", :as => "about"
  get '/contact' => "contact#index", :as => "contact"
  
  get '/help/' => redirect('/help/index')
  get '/help/:page' => "help#show", :as => "help"

  post 'apex_controls/reset'
  post 'apex_parameters/reset'

  post 'operations/delete_all'

  post 'scenarios/simulate_all'

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
