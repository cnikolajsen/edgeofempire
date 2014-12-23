EdgeOfEmpire::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root :to => 'characters#index'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config


  resources :adversaries do
    resources :adversary_armors
    resources :adversary_weapons
    resources :adversary_gears
    resources :adversary_skills
  end
  #resources :character_adventure_logs
  resources :skills
  resources :careers
  resources :races
  resources :equipment
  resources :adventures
  resources :campaigns
  resources :weapons
  resources :weapon_quality_ranks
  resources :weapon_qualities
  resources :weapon_attachments
  resources :armors
  resources :armor_qualities
  resources :armor_attachments
  resources :gears
  resources :talents
  resources :talent_trees
  resources :obligations
  resources :duties
  resources :sidebars
  resources :books

  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
    get "register", :to => "devise/registrations#new"
    get "me", :to => "devise/registrations#edit"
  end

  resources :users do
    resources :characters do
      resources :adventure_logs
      #resources :character_armors
      #resources :character_weapons
      #resources :character_gears
      #resources :character_force_powers
      #resources :character_skills

      # Character routes.
      get 'description' => 'characters#edit', :as => :description
      get 'characteristics' => 'characters#characteristics', :as => :characteristics
      get 'background' => 'characters#background', :as => :background

      # Character obligation routes.
      get 'obligation' => 'character_obligations#show'
      post 'obligation' => 'character_obligations#add_obligation'
      post 'obligation/update' => 'character_obligations#update_obligation'
      get 'obligation/:obligation_id/remove' => 'character_obligations#remove_obligation'

      # Character duty routes.
      get 'duty' => 'character_duties#show'
      post 'duty' => 'character_duties#add_duty'
      post 'duty/update' => 'character_duties#update_duty'
      get 'duty/:duty_id/remove' => 'character_duties#remove_duty'

      # Character motivation routes.
      get 'motivation' => 'character_motivations#show'
      post 'motivation' => 'character_motivations#add_motivation'
      post 'motivation/update' => 'character_motivations#update_motivation'
      get 'motivation/:motivation_id/remove' => 'character_motivations#remove_motivation'

      # States
      get 'creation' => 'characters#set_creation'
      get 'activate' => 'characters#set_activate'
      get 'retire' => 'characters#set_retired'

      # Armor
      get 'armor' => 'character_armors#show'
      post 'armor' => 'character_armors#add_armor'
      get 'armor/:character_armor_id/remove' => 'character_armors#remove_armor', :as => :remove_armor
      get 'armor/:character_armor_id/move/:action_id' => 'character_armors#place_armor', :as => :place_armor

      get 'armor/:character_armor_id/attachments' => 'character_armors#armor_attachment', :as => :modify_armor
      post 'armor/:character_armor_id/attachments' => 'character_armors#add_armor_attachment'
      get 'armor/:armor_id/attachment/:attachment_id/remove' => 'character_armors#remove_armor_attachment'
      get 'armor/:armor_id/attachment/:attachment_id/option/:option_id/add' => 'character_armors#add_armor_attachment_option'
      get 'armor/:armor_id/attachment/:attachment_id/option/:option_id/remove' => 'character_armors#remove_armor_attachment_option'

      # Character talent routes.
      get 'talents' => 'character_talents#show'
      get 'talents/specialization/:spec_num/:spec_id/untrain' => 'character_talents#untrain_specialization'
      get 'talents/:talent_tree_id/:row/:column/learn(/:option/:option_value)' => 'character_talents#learn'
      get 'talents/:talent_tree_id/:row/:column/unlearn' => 'character_talents#unlearn'

      # Character skill routes.
      get 'skills' => 'character_skills#show'
      get 'skills/:skill_id/rank_up' => 'character_skills#rank_up'
      get 'skills/:skill_id/rank_down' => 'character_skills#rank_down'
      post 'skills' => 'character_skills#save_free_skill_ranks'

      # Character Weapon routes.
      get 'weapons' => 'character_weapons#show'
      get 'weapon/:character_weapon_id/attachments' => 'character_weapons#weapon_attachment'
      post 'weapon/:character_weapon_id/attachments' => 'character_weapons#add_weapon_attachment'
      get 'weapon/:weapon_id/attachment/:attachment_id/remove' => 'character_weapons#remove_weapon_attachment'
      get 'weapon/:weapon_id/attachment/:attachment_id/option/:option_id/add' => 'character_weapons#add_weapon_attachment_option'
      get 'weapon/:weapon_id/attachment/:attachment_id/option/:option_id/remove' => 'character_weapons#remove_weapon_attachment_option'

      # Character Gear routes.
      get 'equipment' => 'character_gears#show', :as => :gear
      post 'equipment' => 'character_gears#add_equipment'
      get 'equipment/:character_gear_id/remove(/:custom)' => 'character_gears#remove_equipment', :as => :remove_item
      get 'equipment/:character_gear_id/move/:action_id(/:custom)' => 'character_gears#place_equipment', :as => :place_item
      get 'equipment/:character_gear_id/increase(/:custom)' => 'character_gears#increase_equipment_qty', :as => :increase_item_qty
      get 'equipment/:character_gear_id/decrease(/:custom)' => 'character_gears#decrease_equipment_qty', :as => :decrease_item_qty

      # Character Cybernetics routes.
      get 'cybernetics' => 'character_cybernetics#show'
      post 'cybernetics' => 'character_cybernetics#update'

      # Character Force Power routes.
      get 'force-powers' => 'character_force_powers#show'
      post 'force-powers' => 'character_force_powers#add_force_power'
      get 'force-power/:force_power_id/remove' => 'character_force_powers#remove_force_power'
      get 'force-power/:force_power_id/upgrade/:force_power_upgrade_id/add' => 'character_force_powers#add_force_power_upgrade', :defaults => { format: 'js' }
      get 'force-power/:force_power_id/upgrade/:force_power_upgrade_id/remove' => 'character_force_powers#remove_force_power_upgrade', :defaults => { format: 'js' }

    end
  end

  # Ajax callbacks
  get 'find/species_selection' => 'characters#species_selection'
  get 'find/career_selection' => 'characters#career_selection'
  get 'find/obligation_selection' => 'character_obligations#obligation_selection'
  get 'find/duty_selection' => 'character_duties#duty_selection'
  get 'find/motivation_selection' => 'character_motivations#motivation_selection'
  get 'find/armor_selection' => 'armors#armor_selection'
  get 'find/weapon_selection' => 'weapons#weapons_selection'
  get 'find/armor_attachment_selection' => 'armor_attachments#armor_attachment_selection'
  get 'find/force_power_selection' => 'character_force_powers#force_power_selection'
  get 'find/weapon_attachment_selection' => 'character_weapons#weapon_attachment_selection'
  get 'find/equipment_selection' => 'character_gears#equipment_selection'

  # General pages.
  get "names/human", :to => "pages#human_naming_tables", :as => :human_names
  get "names/bothan", :to => "pages#bothan_naming_tables", :as => :bothan_names
  get "names/rodian", :to => "pages#rodian_naming_tables", :as => :rodian_names
  get "names/trandoshan", :to => "pages#trandoshan_naming_tables", :as => :trandoshan_names
  get "names/twilek", :to => "pages#twilek_naming_tables", :as => :twilek_names
  get "names/droid", :to => "pages#droid_naming_tables", :as => :droid_names
  get "rules", :to => "pages#rules_summary", :as => :rules

  # Adversary Armor routes.
  get 'adversaries/:id/armor' => 'adversary_armors#show' , :as => :adversary_armor
  get 'adversaries/:id/armor/:adversary_armor_id/attachments' => 'adversary_armors#armor_attachment'
  post 'adversaries/:id/armor/:adversary_armor_id/attachments' => 'adversary_armors#add_armor_attachment'
  get 'adversaries/:id/armor/attachment/:attachment_id/remove' => 'adversary_armors#remove_armor_attachment'
  get 'adversaries/:id/armor/attachment/:attachment_id/option/:option_id/add' => 'adversary_armors#add_armor_attachment_option'
  get 'adversaries/:id/armor/attachment/:attachment_id/option/:option_id/remove' => 'adversary_armors#remove_armor_attachment_option'
  #get 'adversaries/find/armor_attachment_selection' => 'adversaries#armor_attachment_selection'

  # Adversary Weapon routes.
  get 'adversaries/:id/weapons' => 'adversary_weapons#show', :as => :adversary_weapons
  get 'adversaries/:id/weapon/:adversary_weapon_id/attachments' => 'adversary_weapons#weapon_attachment'
  post 'adversaries/:id/weapon/:adversary_weapon_id/attachments' => 'adversary_weapons#add_weapon_attachment'
  get 'adversaries/:id/weapon/attachment/:attachment_id/remove' => 'adversary_weapons#remove_weapon_attachment'
  get 'adversaries/:id/weapon/attachment/:attachment_id/option/:option_id/add' => 'adversary_weapons#add_weapon_attachment_option'
  get 'adversaries/:id/weapon/attachment/:attachment_id/option/:option_id/remove' => 'adversary_weapons#remove_weapon_attachment_option'
  get 'adversaries/find/weapon_attachment_selection' => 'adversary_weapons#weapon_attachment_selection'

end
