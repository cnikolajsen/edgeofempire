ActiveAdmin.register Gear do
  permit_params :description, :name, :price, :encumbrance, :rarity
 
  menu :label => "Gear", :parent => "Equipment"

  config.sort_order = "name_asc"

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_gears_url }
       end
     end
   end
end
