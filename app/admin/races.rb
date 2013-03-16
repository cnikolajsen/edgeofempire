ActiveAdmin.register Race do
  config.sort_order = "name_asc"

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_races_url }
       end
     end
   end
end
