ActiveAdmin.register Gear do
  permit_params :description, :name, :price, :encumbrance, :rarity, :image_url,
    gear_models_attributes: [ :id, :gear_id, :name ]

  menu :label => "Gear", :parent => "Equipment"

  config.per_page = 50

  index do |gear|
    column :name
    column :encumbrance
    column :rarity
    column :price
    default_actions
  end

  form do |f|
    f.inputs "Equipment Details" do
      f.input :name
      f.input :description
      f.input :image_url
      f.input :price
      f.input :encumbrance
      f.input :rarity
      f.has_many :gear_models do |em_form|
        em_form.input :name
      end

    end
    f.actions
  end

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_gears_url }
       end
     end
   end
end
