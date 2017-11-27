NTTG3::Application.routes.draw do
  resources :groups
  resources :soil_tests
  resources :soil_tests
  resources :soil_tests
  resources :soil_tests
  resources :supplement_parameters
  resources :manure_controls
  resources :grazing_parameters
  resources :aplcat_parameters
  resources :control_descriptions
  resources :parameter_descriptions
  resources :drainages
  resources :schedules
  resources :crop_schedules
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
  resources :modifications
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
  resources :operations
  resources :scenarios
  resources :counties
  resource :session
  resources :welcomes
  resources :apex_soils
  resources :apex_layers
  resources :users do
    resources :projects
  end

  get '/serve_image/:filename' => 'application#serve'

  get 'projects/upload'
  post 'projects/upload_project'

  resources :projects do
    resources :watersheds do
  		post :simulate, on: :collection
  		get :list, on: :member
  		get :new_scenario, on: :member
  		get :destroy_watershed_scenario, on: :member
      post :download, on: :collection
  		resources :watershed_scenarios
	  end
    resources :locations do
      get :send_to_mapping_site, on: :member
      post :receive_from_mapping_site, on: :member
      get :location_fields, on: :member
    end
    get 'download', on: :member
    get :group, on: :member
    resources :fields do
      resources :scenarios do
		    get 'copy_scenario', on: :member
        get 'copy_other_scenario', on: :collection
        post :download, on: :collection
        resources :aplcat_parameters do
	        get 'aplcat', on: :member
		    end
		    resources :grazing_parameters
		    resources :supplement_parameters
        post :simulate, on: :collection
        resources :operations do
          get :list, on: :collection
          get :cropping_system, on: :collection
          get :crop_schedule, on: :collection
          get 'download', on: :collection
          get :open, on: :collection
          get :delete_all, on: :member
		      post :upload_system, on: :member
        end
        resources :bmps do
          get :list, on: :collection
          post :save_bmps, on: :collection
        end
      end
      resources :weathers do
        member do
          post 'save_simulation'
          post 'save_coordinates'
        end
      end
      get :field_soils, on: :member
      put :field_scenarios, on: :collection
      get 'create_soils', on: :member
      resources :soils do
        get :list, on: :member
        resources :layers do
          get :list, on: :member
        end
		post :save_soils, on: :collection
        get :soil_layers, on: :member
      end
      resources :results do
        get 'sel', on: :member
        get :summary, on: :member
        get :by_soils, on: :member
        get :annual_charts, on: :member
        get :monthly_charts, on: :member
        get :download_apex_files, on: :member
      end
      resources :apex_parameters do
		get 'reset', on: :member
	  end
      resources :apex_controls do
		get 'reset', on: :member
	  end
      resources :apex_soils
      resources :apex_layers
      resources :subareas
      resources :soil_operations do
        get 'download', :on => :collection
      end
      resources :sites
    end
	  get 'copy_project', on: :member
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

  resources :bmplists do
     resources :bmpsublists
  end

  resources :password_resets, only: [:new, :create, :edit, :update]

  #define two name routes, login_path and logout_path
  get '/login' => "sessions#index", :as => "login"
  get '/logout' => "sessions#destroy", :as => "logout"
  get 'sessions/create'
  get 'sessions/destroy'
  get 'users/new'
  post 'weathers/upload_weather'
  root :to => 'welcomes#index'

  get '/about' => "about#index", :as => "about"
  get '/contact' => "contact#index", :as => "contact"

  #get '/help/' => redirect('/help/index')
  get '/help/:page' => "help#show", :as => "help"

  post 'apex_controls/download'
  post 'apex_parameters/reset'
  post 'apex_parameters/download'
  post 'aplcat_parameters/download'
  post 'subareas/download'
  post 'apex_soils/download'
  post 'sites/download'
  post 'operations/delete_all'

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
