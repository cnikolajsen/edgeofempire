ActiveAdmin.register Talent do
  menu :parent => "Careers"

  config.sort_order = "name_asc"

  index do
    column :name
    column :description do |desc|
      truncate(desc.description)
    end
    column :activation
    default_actions
  end
  
  filter :name

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_talents_url }
       end
     end
   end
end
