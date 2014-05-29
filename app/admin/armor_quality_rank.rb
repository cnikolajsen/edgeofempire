ActiveAdmin.register ArmorQualityRank do
  permit_params :ranks, :armor_attachment_id, :armor_quality_id

  menu false #:parent => "Equipment"

  index do
    column :armor_attachment_id do |weapon|
      ArmorAttachment.find_by_id(weapon.armor_attachment_id).name
    end
    column :armor_quality_id do |weapon_quality|
      ArmorQuality.find_by_id(weapon_quality.armor_quality_id).name
    end
    column :ranks

    actions
  end

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_armor_quality_ranks_url }
       end
     end
   end
end
