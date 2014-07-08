ActiveAdmin.register Armor do
  permit_params :name, :description, :defense, :soak, :price, :encumbrance,
    :rarity, :hard_points, :image_url, :armor_category_id,
    armor_models_attributes: [ :id, :armor_id, :name ],
    armor_attachments_armors_attributes: [ :id, :armor_id, :armor_attachment_id ]

  menu :label => "Armor", :parent => "Equipment"

  filter :name
  filter :armor_category
  filter :defense
  filter :soak
  filter :price
  filter :rarity

  config.sort_order = "name_asc"
  config.per_page = 50

  index do |armor|
    selectable_column
    column :name
    column :armor_category
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
      f.input :armor_category
      f.input :description
      f.input :image_url
      f.input :defense
      f.input :soak
      f.input :price
      f.input :encumbrance
      f.input :hard_points
      f.input :rarity
      f.has_many :armor_models do |armor_model_form|
        armor_model_form.input :name
      end
      f.has_many :armor_attachments_armors, :heading => 'Allowed armor attachments' do |wm_form|
        wm_form.input :armor_attachment_id, :as => :select, :collection => ArmorAttachment.all.map{|u| ["#{u.name}", u.id]}
      end
    end
    f.actions
  end

  ArmorCategory.where(:true).each do |i|
    batch_action "Set Category '#{i.name}' on" do |selection|
      Armor.find(selection).each do |armor|
        armor.update_attribute(:armor_category_id, i.id)
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
        format.html { redirect_to admin_armors_url }
      end
    end
  end
end
