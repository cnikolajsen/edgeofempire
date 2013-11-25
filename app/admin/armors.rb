ActiveAdmin.register Armor do
  permit_params :name, :description, :defense, :soak, :price

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
