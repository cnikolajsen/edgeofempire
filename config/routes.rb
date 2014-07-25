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
    resources :character_armors
    resources :character_weapons
    resources :character_gears
    resources :character_force_powers
  end
  resources :skills
  resources :careers
  resources :races
  resources :equipment
  resources :adventures
  resources :campaigns
  resources :weapons do

  end
  resources :weapon_quality_ranks
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

  # General pages.
  get "names/human", :to => "pages#human_naming_tables", :as => :human_names
  get "names/bothan", :to => "pages#bothan_naming_tables", :as => :bothan_names
  get "names/rodian", :to => "pages#rodian_naming_tables", :as => :rodian_names
  get "names/trandoshan", :to => "pages#trandoshan_naming_tables", :as => :trandoshan_names
  get "names/twilek", :to => "pages#twilek_naming_tables", :as => :twilek_names
  get "names/droid", :to => "pages#droid_naming_tables", :as => :droid_names
  get "rules", :to => "pages#rules_summary", :as => :rules

  # Character routes.
  get 'characters/:id/description' => 'characters#edit', :as => :character_description
  get 'characters/:id/characteristics' => 'characters#characteristics', :as => :character_characteristics
  get 'characters/:id/background' => 'characters#background', :as => :character_background
  get 'character/find/species_selection' => 'characters#species_selection'
  get 'character/find/career_selection' => 'characters#career_selection'
  get 'characters/:id/log' => 'character_adventure_logs#show', :as => :log

  # Character state routes.
  get 'characters/:id/creation' => 'characters#set_creation', :as => :creation_character
  get 'characters/:id/activate' => 'characters#set_activate', :as => :activate_character
  get 'characters/:id/retire' => 'characters#set_retired', :as => :retire_character

  # Character talent routes.
  get 'characters/:id/talents' => 'character_talents#show', :as => :character_talents
  get 'characters/:id/talents/specialization/:spec_num/:spec_id/untrain' => 'character_talents#untrain_specialization'
  get 'characters/:id/talents/:talent_tree_id/:row/:column/learn(/:option/:option_value)' => 'character_talents#learn'#, :defaults => {:format => "js"}
  get 'characters/:id/talents/:talent_tree_id/:row/:column/unlearn' => 'character_talents#unlearn'#, :defaults => {:format => "js"}

  # Character skill routes.
  get 'characters/:id/skills' => 'characters#skills', :as => :character_skills
  get 'characters/:id/skills/:skill_id/rank_up' => 'characters#character_skill_rank_up'
  get 'characters/:id/skills/:skill_id/rank_down' => 'characters#character_skill_rank_down'

  # Character obligation routes.
  get 'characters/:id/obligation' => 'character_obligations#show', :as => :character_obligation
  get 'character/find/obligation_selection' => 'character_obligations#obligation_selection'
  post 'characters/:id/obligation' => 'character_obligations#add_obligation'
  post 'characters/:id/obligation/update' => 'character_obligations#update_obligation'
  get 'characters/:id/obligation/:obligation_id/remove' => 'character_obligations#remove_obligation'

  # Character motivation routes.
  get 'characters/:id/motivation' => 'character_motivations#show', :as => :character_motivation
  get 'character/find/motivation_selection' => 'character_motivations#motivation_selection'
  post 'characters/:id/motivation' => 'character_motivations#add_motivation'
  post 'characters/:id/motivation/update' => 'character_motivations#update_motivation'
  get 'characters/:id/motivation/:motivation_id/remove' => 'character_motivations#remove_motivation'

  # Character Armor routes.
  get 'characters/:id/armor' => 'character_armors#show' , :as => :character_armor
  get 'characters/:id/armor/:character_armor_id/attachments' => 'character_armors#armor_attachment'
  post 'characters/:id/armor/:character_armor_id/attachments' => 'character_armors#add_armor_attachment'
  get 'characters/:id/armor/attachment/:attachment_id/remove' => 'character_armors#remove_armor_attachment'
  get 'characters/:id/armor/attachment/:attachment_id/option/:option_id/add' => 'character_armors#add_armor_attachment_option'
  get 'characters/:id/armor/attachment/:attachment_id/option/:option_id/remove' => 'character_armors#remove_armor_attachment_option'
  get 'character/find/armor_attachment_selection' => 'characters#armor_attachment_selection'

  # Character Weapon routes.
  get 'characters/:id/weapons' => 'character_weapons#show', :as => :character_weapons
  get 'characters/:id/weapon/:character_weapon_id/attachments' => 'character_weapons#weapon_attachment'
  post 'characters/:id/weapon/:character_weapon_id/attachments' => 'character_weapons#add_weapon_attachment'
  get 'characters/:id/weapon/attachment/:attachment_id/remove' => 'character_weapons#remove_weapon_attachment'
  get 'characters/:id/weapon/attachment/:attachment_id/option/:option_id/add' => 'character_weapons#add_weapon_attachment_option'
  get 'characters/:id/weapon/attachment/:attachment_id/option/:option_id/remove' => 'character_weapons#remove_weapon_attachment_option'
  get 'character/find/weapon_attachment_selection' => 'character_weapons#weapon_attachment_selection'

  # Character Gear routes.
  get 'characters/:id/equipment' => 'character_gears#show', :as => :character_gear
  post 'characters/:id/equipment' => 'character_gears#add_equipment'
  get 'characters/:id/equipment/:character_gear_id/remove(/:custom)' => 'character_gears#remove_equipment', :as => :remove_item
  get 'characters/:id/equipment/:character_gear_id/move/:action_id(/:custom)' => 'character_gears#place_equipment', :as => :place_item
  get 'characters/:id/equipment/:character_gear_id/increase(/:custom)' => 'character_gears#increase_equipment_qty', :as => :increase_item_qty
  get 'characters/:id/equipment/:character_gear_id/decrease(/:custom)' => 'character_gears#decrease_equipment_qty', :as => :decrease_item_qty
  get 'character/find/equipment_selection' => 'character_gears#equipment_selection'

  # Character Force Power routes.
  get 'characters/:id/force-powers' => 'character_force_powers#show', :as => :character_force_powers
  get 'character/find/force_power_selection' => 'character_force_powers#force_power_selection'
  post 'characters/:id/force-powers' => 'character_force_powers#add_force_power'
  get 'characters/:id/force-power/:force_power_id/remove' => 'character_force_powers#remove_force_power'
  get 'characters/:id/force-power/:force_power_id/upgrade/:force_power_upgrade_id/add' => 'character_force_powers#add_force_power_upgrade', :defaults => {:format => "js"}
  get 'characters/:id/force-power/:force_power_id/upgrade/:force_power_upgrade_id/remove' => 'character_force_powers#remove_force_power_upgrade', :defaults => {:format => "js"}

end
