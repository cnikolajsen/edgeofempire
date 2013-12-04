EdgeOfEmpire::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root :to => 'pages#home'

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
  get "rules", :to => "pages#rules_summary"
  # get "careers/index"

  # Example of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Example of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  get 'characters/:id/talents' => 'characters#talents', :as => :character_talents
  get 'characters/:id/skills' => 'characters#skills', :as => :character_skills
  get 'characters/:id/armor' => 'characters#armor', :as => :character_armor
  get 'characters/:id/weapons' => 'characters#weapons', :as => :character_weapons
  get 'characters/:id/equipment' => 'characters#equipment', :as => :character_gear
  get 'characters/:id/creation' => 'characters#set_creation', :as => :creation_character
  get 'characters/:id/activate' => 'characters#set_activate', :as => :activate_character
  get 'characters/:id/retire' => 'characters#set_retired', :as => :retire_character

  get 'characters/:id/talents/specialization/:spec_num/:spec_id/untrain' => 'characters#untrain_specialization'

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
