ActiveAdmin.register Armor do
  permit_params :name, :description, :defense, :soak, :price, :encumbrance,
    :rarity, :hard_points

  menu :label => "Armor", :parent => "Equipment"

  config.sort_order = "name_asc"

  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_armors_url }
      end
    end
  end
end
