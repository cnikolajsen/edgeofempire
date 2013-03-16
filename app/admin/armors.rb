ActiveAdmin.register Armor do
  menu :label => "Armor", :parent => "Equipment"

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_armors_url }
       end
     end
   end
end
