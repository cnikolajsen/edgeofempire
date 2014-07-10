ActiveAdmin.register ArmorAttachment do
  permit_params :name, :description, :price, :hard_points, :stat_bonus,
  armor_quality_ranks_attributes: [ :id, :ranks, :armor_attachment_id, :armor_quality_id ],
  armor_attachment_modification_options_attributes: [ :id, :skill_id, :talent_id ],
  armor_attachment_attachments_groups_attributes: [ :id, :armor_attachment_id, :attachment_group_id ]

  menu false

  config.sort_order = "name_asc"
  config.per_page = 50

  filter :name
  filter :hard_points
  filter :price

  action_item do
    link_to "Armor", admin_armors_path
  end

  index do |armor|
    selectable_column
    column :name
    column :hard_points
    column :price
    actions
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

      #f.has_many :armor_attachment_attachments_groups do |wm_form|
      #  wm_form.input :attachment_group_id, :as => :select, :collection => AttachmentGroup.all.map{|u| ["#{u.name}", u.id]}
      #end
    end
    f.actions
  end

  #batch_priority = 0
  #AttachmentGroup.where(:true).each do |i|
  #  batch_priority += 1
  #  batch_action "Set'#{i.name}' attachment group on", :priority => batch_priority do |selection|
  #    ArmorAttachment.find(selection).each do |armor|
  #      ArmorAttachmentAttachmentsGroup.where(:armor_attachment_id => armor.id, :attachment_group_id => i.id).first_or_create
  #    end
  #    redirect_to :back
  #  end
  #end

end
