ActiveAdmin.register Obligation do
  permit_params :description, :name, :range, :career_id

  menu :label => "Obligation", :parent => "Character Backgrounds"

  config.sort_order = "id_asc"

  config.per_page = 50

  index do |obligation|
    column :career
    column :name
    column :description do |desc|
      simple_format desc.description
    end
    actions
  end

  #preserve_default_filters!
  filter :name
  filter :career

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_obligations_url }
       end
     end
   end
end
