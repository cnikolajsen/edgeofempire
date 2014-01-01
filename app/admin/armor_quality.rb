ActiveAdmin.register ArmorQuality do
  permit_params :description, :name, :trigger

  menu :label => "Armor Qualities", :parent => "Equipment"

  config.sort_order = "name_asc"

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_armor_qualities_url }
       end
     end
   end
end
