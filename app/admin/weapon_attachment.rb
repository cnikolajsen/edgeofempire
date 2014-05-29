ActiveAdmin.register WeaponAttachment do
  permit_params :name, :description, :price, :hard_points, :damage_bonus,
  weapon_attachment_quality_ranks_attributes: [ :id, :ranks, :weapon_attachment_id, :weapon_quality_id ],
  weapon_attachment_modification_options_attributes: [ :id, :skill_id, :talent_id, :damage_bonus, :weapon_quality_id, :weapon_quality_rank, :custom ]

  menu :label => "Weapon Attachments", :parent => "Equipment"

  config.sort_order = "name_asc"
  config.per_page = 50

  index do |weapon|
    column :name
    column :hard_points
    column :price
    actions
  end

  form do |f|
    f.inputs "Weapon Attachment Details" do
      f.input :name
      f.input :description
      f.input :hard_points
      f.input :price
      f.has_many :weapon_attachment_quality_ranks do |wqr_form|
        wqr_form.input :weapon_quality_id, :as => :select, :collection => WeaponQuality.all
        wqr_form.input :ranks
      end
      f.input :damage_bonus
      f.has_many :weapon_attachment_modification_options do |amo_form|
        if (amo_form.object.skill_id.nil? and amo_form.object.created_at.nil?) or !amo_form.object.skill_id.nil?
          amo_form.input :skill_id, :as => :select, :collection => Skill.all
        end
        if (amo_form.object.talent_id.nil? and amo_form.object.created_at.nil?) or !amo_form.object.talent_id.nil?
          amo_form.input :talent_id, :as => :select, :collection => Talent.all
        end
        if (amo_form.object.damage_bonus.nil? and amo_form.object.created_at.nil?) or !amo_form.object.damage_bonus.nil?
          amo_form.input :damage_bonus
        end
        if (amo_form.object.weapon_quality_id.nil? and amo_form.object.created_at.nil?) or !amo_form.object.weapon_quality_id.nil?
          amo_form.input :weapon_quality_id, :as => :select, :collection => WeaponQuality.all
          amo_form.input :weapon_quality_rank
        end
        if (amo_form.object.custom.blank? and amo_form.object.created_at.nil?) or !amo_form.object.custom.blank?
          amo_form.input :custom
        end
      end

    end
    f.actions
  end

end
