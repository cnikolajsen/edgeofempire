EdgeOfEmpire::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users

  resources :characters
  #resources :characters do
  #  resources :character_skills
  #end
  resources :skills
  resources :careers
  resources :races
  resources :equipment
  resources :adventures
  resources :campaigns
  resources :weapons
  resources :armor
  resources :gear
  resources :talents
  resources :obligations

  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
    get "register", :to => "devise/registrations#new"
    get "me", :to => "devise/registrations#edit"
  end

  get "home/index"
  get "names/human", :to => "pages#human_naming_tables"
  get "names/bothan", :to => "pages#bothan_naming_tables"
  get "names/rodian", :to => "pages#rodian_naming_tables"
  get "names/trandoshan", :to => "pages#trandoshan_naming_tables"
  get "names/twilek", :to => "pages#twilek_naming_tables"
  get "names/droid", :to => "pages#droid_naming_tables"
  # get "careers/index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  match 'characters/:id/talents' => 'characters#talents', :as => :character_talents
  match 'characters/:id/skills' => 'characters#skills', :as => :character_skills
  match 'characters/:id/armor' => 'characters#armor', :as => :character_armor
  match 'characters/:id/weapons' => 'characters#weapons', :as => :character_weapons
  match 'characters/:id/equipment' => 'characters#equipment', :as => :character_gear
  match 'characters/:id/creation' => 'characters#set_creation', :as => :creation_character
  match 'characters/:id/activate' => 'characters#set_activate', :as => :activate_character
  match 'characters/:id/retire' => 'characters#set_retired', :as => :retire_character

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
   root :to => 'pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
