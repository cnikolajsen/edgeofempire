ActiveAdmin.register Specialization do
  permit_params :description, :name, :career_id

  menu false

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_specializations_url }
       end
     end
   end
end
