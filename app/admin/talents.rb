ActiveAdmin.register Talent do
  menu :parent => "Careers"

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_talents_url }
       end
     end
   end
end
