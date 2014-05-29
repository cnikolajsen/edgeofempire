ActiveAdmin.register Armor do
  permit_params :name, :description, :defense, :soak, :price, :encumbrance,
    :rarity, :hard_points, :image_url,
    armor_models_attributes: [ :id, :armor_id, :name ]

  menu :label => "Armor", :parent => "Equipment"

  config.sort_order = "name_asc"
  config.per_page = 50

  index do |armor|
    column :name
    column :defense
    column :soak
    column :price
    column :encumbrance
    column :hard_points
    column :rarity

    actions
  end

  form do |f|
    f.inputs "Armor Details" do
      f.input :name
      f.input :description
      f.input :image_url
      f.input :defense
      f.input :soak
      f.input :price
      f.input :encumbrance
      f.input :hard_points
      f.input :rarity
      f.has_many :armor_models do |wm_form|
        wm_form.input :name
      end

    end
    f.actions
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def create
      create! do |format|
        format.html { redirect_to admin_armors_url }
      end
    end
  end
end
