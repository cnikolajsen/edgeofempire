ActiveAdmin.register Motivation do
  permit_params :description, :name, :category

  menu :label => "Motivation", :parent => "Character Backgrounds"

  config.sort_order = "category_asc"

  config.per_page = 50

  index do |motivation|
    column :category
    column :name
    column :description
    actions
  end

form do |f|
    f.inputs "Motivation Details" do
      f.input :name
      f.input :description
      f.input :category, :as => :select, :collection => ["Ambition", "Cause", "Relationship"]
    end
    f.actions
  end

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_motivations_url }
       end
     end
   end
end
