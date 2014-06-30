EdgeOfEmpire::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root :to => 'characters#index'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :characters do
    resources :character_adventure_logs
  end
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

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
    get "register", :to => "devise/registrations#new"
    get "me", :to => "devise/registrations#edit"
  end

  get "names/human", :to => "pages#human_naming_tables", :as => :human_names
  get "names/bothan", :to => "pages#bothan_naming_tables", :as => :bothan_names
  get "names/rodian", :to => "pages#rodian_naming_tables", :as => :rodian_names
  get "names/trandoshan", :to => "pages#trandoshan_naming_tables", :as => :trandoshan_names
  get "names/twilek", :to => "pages#twilek_naming_tables", :as => :twilek_names
  get "names/droid", :to => "pages#droid_naming_tables", :as => :droid_names
  get "rules", :to => "pages#rules_summary", :as => :rules

  get 'characters/:id/description' => 'characters#edit', :as => :character_description
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
  get 'characters/:id/skills/:skill_id/rank_up' => 'characters#character_skill_rank_up'
  get 'characters/:id/skills/:skill_id/rank_down' => 'characters#character_skill_rank_down'
  get 'characters/:id/armor' => 'characters#armor', :as => :character_armor
  get 'characters/:id/weapons' => 'characters#weapons', :as => :character_weapons
  get 'characters/:id/equipment' => 'characters#equipment', :as => :character_gear
  post 'characters/:id/equipment' => 'characters#add_equipment'
  get 'characters/:id/equipment/:character_gear_id/remove(/:custom)' => 'characters#remove_equipment', :as => :remove_item
  get 'characters/:id/equipment/:character_gear_id/move/:action_id(/:custom)' => 'characters#place_equipment', :as => :place_item
  get 'characters/:id/equipment/:character_gear_id/increase(/:custom)' => 'characters#increase_equipment_qty', :as => :increase_item_qty
  get 'characters/:id/equipment/:character_gear_id/decrease(/:custom)' => 'characters#decrease_equipment_qty', :as => :decrease_item_qty
  get 'character/find/equipment_selection' => 'characters#equipment_selection'
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
  get 'character/find/force_power_selection' => 'characters#force_power_selection'
  get 'characters/:id/force-powers' => 'characters#force_powers', :as => :character_force_powers
  post 'characters/:id/force-powers' => 'characters#add_force_power'
  get 'characters/:id/force-power/:force_power_id/remove' => 'characters#remove_force_power'
  get 'characters/:id/force-power/:force_power_id/upgrade/:force_power_upgrade_id/add' => 'characters#add_force_power_upgrade'
  get 'characters/:id/force-power/:force_power_id/upgrade/:force_power_upgrade_id/remove' => 'characters#remove_force_power_upgrade'
  get 'characters/:id/log' => 'character_adventure_logs#show', :as => :log
end
