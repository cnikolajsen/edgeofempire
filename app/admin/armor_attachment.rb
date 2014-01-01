ActiveAdmin.register ArmorAttachment do
  permit_params :name, :description, :price, :hard_points, armor_quality_ranks_attributes: [ :id, :ranks, :armor_attachment_id, :armor_quality_id ]

  menu :label => "Armor Attachments", :parent => "Equipment"

  config.sort_order = "name_asc"
  config.per_page = 50

  index do |armor|
    column :name
    column :hard_points
    column :price
    default_actions
  end

  form do |f|
    f.inputs "Armor Attachment Details" do
      f.input :name
      f.input :description
      f.input :hard_points
      f.input :price
      f.has_many :armor_quality_ranks do |wqr_form|
        wqr_form.input :armor_quality_id, :as => :select, :collection => ArmorQuality.all
        wqr_form.input :ranks
      end

    end
    f.actions
  end

end
