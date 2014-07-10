ActiveAdmin.register WeaponQuality do
	permit_params :description, :name, :trigger

  menu false

  action_item do
    link_to "Weapons", admin_weapons_path
  end

  config.sort_order = "name_asc"

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_weapon_qualities_url }
       end
     end
   end
end
