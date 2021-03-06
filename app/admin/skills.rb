ActiveAdmin.register Skill do
  permit_params :description, :name, :characteristic

  menu :parent => "Careers"

  config.sort_order = "name_asc"
  config.per_page = 10

  filter :name
  filter :characteristic, :as => :select, :collection => ['Agility', 'Brawn', 'Cunning', 'Intellect', 'Presence', 'Willpower']

  index do
    column :name
    column :description do |desc|
      simple_format(text_replace_tokens(desc.description))
    end
    column :characteristic
    actions
  end

  form do |f|
    f.inputs "Skill Details" do
      f.input :name
      f.input :description
      f.input :characteristic, :as => :select, :collection => ['Agility', 'Brawn', 'Cunning', 'Intellect', 'Presence', 'Willpower']
    end
    f.actions
  end

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def create
      create! do |format|
        format.html { redirect_to admin_skills_url }
      end
    end

    def destroy
      @skill = Skill.find(params[:id])

      # Delete the skill from all characters.
      CharacterSkill.where('skill_id = ?', @skill.id).each do |character_skill|
        character_skill.destroy
      end

      # Delete the skill itself.
      @skill.destroy

      respond_to do |format|
        format.html { redirect_to admin_skills_url, notice: 'Skill was successfully deleted.'  }
        format.json { head :no_content }
      end
    end
  end
end
