ActiveAdmin.register Gear do
  permit_params :description, :name, :price, :encumbrance, :rarity, :image_url,
    :gear_category_id,
    gear_models_attributes: [ :id, :gear_id, :name ]

  menu :label => "Gear", :parent => "Equipment"

  action_item do
    link_to "Categories", admin_gear_categories_path
  end

  config.per_page = 50

  index do |gear|
    selectable_column
    column :name
    column :gear_category
    column :price
    column :encumbrance
    column :rarity
    actions
  end

  form do |f|
    f.inputs "Equipment Details" do
      f.input :name
      f.input :gear_category
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

  GearCategory.where(:true).each do |i|
    batch_action "Set Category '#{i.name}' on" do |selection|
      Gear.find(selection).each do |gear|
        gear.update_attribute(:gear_category_id, i.id)
      end
      redirect_to :back
    end
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def create
      create! do |format|
        format.html { redirect_to admin_gears_url }
      end
    end
  end
end
