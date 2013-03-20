ActiveAdmin.register Specialization do
  menu false

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_specializations_url }
       end
     end
   end
end
