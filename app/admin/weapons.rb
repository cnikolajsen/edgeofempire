ActiveAdmin.register Weapon do
  permit_params :crit, :damage, :description, :name, :price, :skill_id, :range,
    :encumbrance, :rarity, :hard_points, :image_url,
    weapon_quality_ranks_attributes: [ :id, :ranks, :weapon_id, :weapon_quality_id ],
    weapon_models_attributes: [ :id, :weapon_id, :name ]

  menu :label => "Weapons", :parent => "Equipment"

  config.sort_order = "name_asc"
  config.per_page = 50

  index do |weapon|
    column :name
    column :skill_id do |s|
      skill = Skill.find_by_id(s.skill_id)
      unless skill.nil?
        skill.name
      end
    end
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
    default_actions
  end

  form do |f|
    f.inputs "Weapon Details" do
      f.input :name
      f.input :description
      f.input :image_url
      f.input :skill_id, :as => :select, :collection => Skill.where("name IN ('Brawl', 'Gunnery', 'Melee', 'Ranged (Light)', 'Ranged (Heavy)')")
      f.input :damage
      f.input :crit
      f.input :range, :as => :select, :collection => ['Short', 'Medium', 'Long', 'Extreme', 'Engaged']
      f.input :price
      f.input :encumbrance
      f.input :hard_points
      f.input :rarity
      f.has_many :weapon_quality_ranks do |wqr_form|
        wqr_form.input :weapon_quality_id, :as => :select, :collection => WeaponQuality.all
        wqr_form.input :ranks
      end
      f.has_many :weapon_models do |wm_form|
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
        format.html { redirect_to admin_weapons_url }
      end
    end
  end
end
