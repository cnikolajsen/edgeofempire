ActiveAdmin.register Career do
  index do                            
    column :name                     
    column :description                     
    default_actions                   
  end
  
  config.sort_order = "name_asc"
  
  config.filters = false


  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_careers_url }
       end
     end
   end
end
