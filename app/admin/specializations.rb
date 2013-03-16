ActiveAdmin.register Specialization do
  menu :parent => "Careers"

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_specializations_url }
       end
     end
   end
end
