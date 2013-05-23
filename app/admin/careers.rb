ActiveAdmin.register Career do
  index do
    column :name
    column :description do |career|
      career.description.html_safe
    end
    default_actions
  end
  
  form do |f|
    f.inputs "Career Details" do
      f.input :name
      f.input :description
      
      f.has_many :career_skills do |skill_form|
        skill_form.input :skill_id, :as => :select, :collection => Skill.all
      end
      
    end
    f.actions
  end

  config.sort_order = "name_asc"
  config.filters = false

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_careers_url }
       end
     end
   end
end
