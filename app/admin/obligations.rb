ActiveAdmin.register Obligation do
  permit_params :description, :name, :range
  
  #menu :label => "Obligation", :parent => "Equipment"

  config.sort_order = "id_asc"

  config.per_page = 50

  index do |obligation|
    column :range
    column :name
    column :description
    default_actions
  end

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_obligations_url }
       end
     end
   end
end
