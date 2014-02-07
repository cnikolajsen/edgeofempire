EdgeOfEmpire::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root :to => 'characters#index'

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
  resources :weapon_qualities
  resources :weapon_attachments
  resources :armor
  resources :armor_qualities
  resources :armor_attachments
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

  get 'characters/:id/description' => 'characters#edit', :as => :character_description

  get 'characters/:id/career' => 'characters#career', :as => :character_career
  get 'characters/:id/species' => 'characters#species', :as => :character_species
  get 'characters/:id/characteristics' => 'characters#characteristics', :as => :character_characteristics
  get 'characters/:id/background' => 'characters#background', :as => :character_background

  get 'characters/:id/obligation' => 'characters#obligation', :as => :character_obligation
  get 'character/find/obligation_selection' => 'characters#obligation_selection'
  post 'characters/:id/obligation' => 'characters#add_obligation'
  post 'characters/:id/obligation/update' => 'characters#update_obligation'
  get 'characters/:id/obligation/:obligation_id/remove' => 'characters#remove_obligation'

  get 'characters/:id/motivation' => 'characters#motivation', :as => :character_motivation
  get 'character/find/motivation_selection' => 'characters#motivation_selection'
  post 'characters/:id/motivation' => 'characters#add_motivation'
  post 'characters/:id/motivation/update' => 'characters#update_motivation'
  get 'characters/:id/motivation/:motivation_id/remove' => 'characters#remove_motivation'

  get 'characters/:id/talents' => 'characters#talents', :as => :character_talents
  get 'characters/:id/skills' => 'characters#skills', :as => :character_skills
  post 'characters/:id/skills' => 'characters#save_character_skills'
  get 'characters/:id/armor' => 'characters#armor', :as => :character_armor
  get 'characters/:id/weapons' => 'characters#weapons', :as => :character_weapons
  get 'characters/:id/equipment' => 'characters#equipment', :as => :character_gear
  get 'characters/:id/creation' => 'characters#set_creation', :as => :creation_character
  get 'characters/:id/activate' => 'characters#set_activate', :as => :activate_character
  get 'characters/:id/retire' => 'characters#set_retired', :as => :retire_character

  get 'characters/:id/talents/specialization/:spec_num/:spec_id/untrain' => 'characters#untrain_specialization'

  get 'characters/:id/armor/:character_armor_id/attachments' => 'characters#armor_attachment'
  post 'characters/:id/armor/:character_armor_id/attachments' => 'characters#add_armor_attachment'
  get 'characters/:id/armor/attachment/:attachment_id/remove' => 'characters#remove_armor_attachment'
  get 'characters/:id/armor/attachment/:attachment_id/option/:option_id/add' => 'characters#add_armor_attachment_option'
  get 'characters/:id/armor/attachment/:attachment_id/option/:option_id/remove' => 'characters#remove_armor_attachment_option'

  get 'characters/:id/weapon/:character_weapon_id/attachments' => 'characters#weapon_attachment'
  post 'characters/:id/weapon/:character_weapon_id/attachments' => 'characters#add_weapon_attachment'
  get 'characters/:id/weapon/attachment/:attachment_id/remove' => 'characters#remove_weapon_attachment'
  get 'characters/:id/weapon/attachment/:attachment_id/option/:option_id/add' => 'characters#add_weapon_attachment_option'
  get 'characters/:id/weapon/attachment/:attachment_id/option/:option_id/remove' => 'characters#remove_weapon_attachment_option'

  get 'character/find/species_selection' => 'characters#species_selection'
  get 'character/find/career_selection' => 'characters#career_selection'
  get 'character/find/armor_attachment_selection' => 'characters#armor_attachment_selection'
  get 'character/find/weapon_attachment_selection' => 'characters#weapon_attachment_selection'
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
