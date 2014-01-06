ActiveAdmin.register ArmorAttachment do
  permit_params :name, :description, :price, :hard_points,
  armor_quality_ranks_attributes: [ :id, :ranks, :armor_attachment_id, :armor_quality_id ],
  armor_attachment_modification_options_attributes: [ :id, :skill_id, :talent_id ]

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
      f.has_many :armor_attachment_modification_options do |amo_form|
        amo_form.input :skill_id, :as => :select, :collection => Skill.all
        amo_form.input :talent_id, :as => :select, :collection => Talent.all
      end

    end
    f.actions
  end

end
