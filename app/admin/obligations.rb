ActiveAdmin.register Obligation do
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
