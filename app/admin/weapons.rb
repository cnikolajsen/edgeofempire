ActiveAdmin.register Weapon do
  menu :label => "Weapons", :parent => "Equipment"

  config.sort_order = "name_asc"
  config.per_page = 10

  index do |weapon|
    column :name
    column :skill_id do |skill|
      Skill.find_by_id(skill.skill_id).name
    end
    column :damage
    column :crit
    column :range
    column :price
    column "Special" do |weapon|
      render "weapon_qualties", :qualities => weapon.weapon_quality_ranks
    end
    default_actions
  end

  form do |f|
    f.inputs "Weapon Details" do
      f.input :name
      f.input :description
      f.input :skill_id, :as => :select, :collection => Skill.where("name IN ('Brawl', 'Gunnery', 'Melee', 'Ranged (Light)', 'Ranged (Heavy)')")
      f.input :damage
      f.input :crit  
      f.input :range, :as => :select, :collection => ['Short', 'Medium', 'Long', 'Engaged']  
      f.input :price
      f.has_many :weapon_quality_ranks do |wqr_form|
        wqr_form.input :weapon_quality_id, :as => :select, :collection => WeaponQuality.all
        wqr_form.input :ranks
      end
      
    end
    f.actions
  end
  
  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_weapons_url }
       end
     end
   end
end
