ActiveAdmin.register Gear do
  permit_params :description, :name, :price, :encumbrance, :rarity, :image_url

  menu :label => "Gear", :parent => "Equipment"

  config.per_page = 50

  index do |armor|
    column :name
    column :encumbrance
    column :rarity
    column :price
    default_actions
  end

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_gears_url }
       end
     end
   end
end
