ActiveAdmin.register Obligation do
  permit_params :description, :name, :range
  
  #menu :label => "Obligation", :parent => "Equipment"

  config.sort_order = "id_asc"

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_obligations_url }
       end
     end
   end
end
