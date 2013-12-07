ActiveAdmin.register Armor do
  permit_params :name, :description, :defense, :soak, :price, :encumbrance,
    :rarity, :hard_points, :image_url

  menu :label => "Armor", :parent => "Equipment"

  config.sort_order = "name_asc"
  config.per_page = 50

  index do |armor|
    column :name
    column :defense
    column :soak
    column :encumbrance
    column :hard_points
    column :rarity
    column :price
    default_actions
  end

  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_armors_url }
      end
    end
  end
end
