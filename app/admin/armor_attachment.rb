ActiveAdmin.register ArmorAttachment do
  permit_params :name, :description, :price, :hard_points, :stat_bonus,
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
      f.input :stat_bonus, :as => :select, :collection => [['Brawn', 'brawn'], ['Agility', 'agility'], ['Intellect', 'intellect'], ['Cunning', 'cunning'], ['Willpower', 'willpower'], ['Presence', 'presence']]
      f.has_many :armor_attachment_modification_options do |amo_form|
        if (amo_form.object.skill_id.nil? and amo_form.object.created_at.nil?) or !amo_form.object.skill_id.nil?
          amo_form.input :skill_id, :as => :select, :collection => Skill.all
        end
        if (amo_form.object.talent_id.nil? and amo_form.object.created_at.nil?) or !amo_form.object.talent_id.nil?
          amo_form.input :talent_id, :as => :select, :collection => Talent.all
        end
      end

    end
    f.actions
  end

end
