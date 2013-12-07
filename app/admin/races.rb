ActiveAdmin.register Race do
  permit_params :agility, :brawn, :cunning, :description, :intellect, :name,
    :presence, :special_ability, :starting_experience, :strain_threshold,
    :willpower, :wound_threshold, :image_url,
    race_skills_attributes: [ :id, :race_id, :skill_id, :ranks ],
    race_talents_attributes: [ :id, :race_id, :talent_id, :ranks ]

  config.sort_order = "name_asc"

  index do |weapon|
    column :name
    column :brawn
    column :agility
    column :cunning
    column :presence
    column :intellect
    column :willpower
    default_actions
  end

  form do |f|
    f.inputs "Species Details" do
      f.input :name
      f.input :description
      f.input :image_url
      f.input :wound_threshold
      f.input :strain_threshold
      f.input :starting_experience
      f.input :special_ability
      f.input :brawn
      f.input :agility
      f.input :cunning
      f.input :presence
      f.input :intellect
      f.input :willpower
      f.has_many :race_skills do |rs_form|
        rs_form.input :skill_id, :as => :select, :collection => Skill.all
        rs_form.input :ranks
      end
      f.has_many :race_talents do |rt_form|
        rt_form.input :talent_id, :as => :select, :collection => Talent.all
        rt_form.input :ranks
      end
    end
    f.actions
  end

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_races_url }
       end
     end
   end
end
