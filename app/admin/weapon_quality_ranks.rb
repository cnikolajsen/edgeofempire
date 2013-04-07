ActiveAdmin.register WeaponQualityRank do
  menu false #:parent => "Equipment"
  
  index do
    column :weapon_id do |weapon|
      Weapon.find_by_id(weapon.weapon_id).name
    end
    column :weapon_quality_id do |weapon_quality|
      WeaponQuality.find_by_id(weapon_quality.weapon_quality_id).name
    end
    column :ranks
    
    default_actions
  end

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_weapon_quality_ranks_url }
       end
     end
   end
  
end
