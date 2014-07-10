ActiveAdmin.register ArmorQuality do
  permit_params :description, :name, :trigger

  menu false

  action_item do
    link_to "Armor", admin_armors_path
  end

  config.sort_order = "name_asc"

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_armor_qualities_url }
       end
     end
   end
end
