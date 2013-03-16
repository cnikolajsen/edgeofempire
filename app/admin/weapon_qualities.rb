ActiveAdmin.register WeaponQuality do
  menu :label => "Weapon Qualities", :parent => "Equipment"
  
  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_weapon_qualities_url }
       end
     end
   end
end
