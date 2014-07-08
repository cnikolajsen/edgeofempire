ActiveAdmin.register Weapon do
  permit_params :crit, :damage, :description, :name, :price, :skill_id, :range,
    :encumbrance, :rarity, :hard_points, :image_url, :weapon_category_id,
    weapon_quality_ranks_attributes: [ :id, :ranks, :weapon_id, :weapon_quality_id ],
    weapon_models_attributes: [ :id, :weapon_id, :name ],
    weapon_attachments_weapons_attributes: [ :id, :weapon_id, :weapon_attachment_id ]

  menu :label => "Weapons", :parent => "Equipment"

  config.sort_order = "name_asc"
  config.per_page = 50

  index do |weapon|
    selectable_column
    column :name
    column :category do |cat|
      cat.name
    end
    column :weapon_category
    column :skill
    column :damage
    column :crit
    column :range
    column :encumbrance
    column :hard_points
    column :price
    column :rarity
    column "Special" do |weapon|
      render "weapon_qualties", :qualities => weapon.weapon_quality_ranks
    end
    column "Attachments" do |weapon|
      weapon.attachments.count
    end
    actions
  end

  form do |f|
    f.inputs "Weapon Details" do
      f.input :name
      f.input :description
      f.input :image_url
      f.input :skill_id, :as => :select, :collection => Skill.where("name IN ('Brawl', 'Gunnery', 'Melee', 'Ranged (Light)', 'Ranged (Heavy)')")
      #f.input :category_id, :as => :select, :collection => WeaponCategory.where(:true)
      f.input :weapon_category
      f.input :damage
      f.input :crit
      f.input :range, :as => :select, :collection => ['Short', 'Medium', 'Long', 'Extreme', 'Engaged']
      f.input :encumbrance
      f.input :hard_points
      f.input :price
      f.input :rarity
      f.has_many :weapon_quality_ranks do |wqr_form|
        wqr_form.input :weapon_quality_id, :as => :select, :collection => WeaponQuality.all
        wqr_form.input :ranks
      end
      f.has_many :weapon_models do |wm_form|
        wm_form.input :name
      end
      f.has_many :weapon_attachments_weapons, :heading => 'Allowed weapon attachments' do |wm_form|
        wm_form.input :weapon_attachment_id, :as => :select, :collection => WeaponAttachment.all.map{|u| ["#{u.name}", u.id]}
      end

    end
    f.actions
  end

  WeaponCategory.where(:true).each do |i|
    batch_action "Set Category '#{i.name}' on" do |selection|
      Weapon.find(selection).each do |weapon|
        weapon.update_attribute(:weapon_category_id, i.id)
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
        format.html { redirect_to admin_weapons_url }
      end
    end
  end
end
