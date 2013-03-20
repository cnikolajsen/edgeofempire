ActiveAdmin.register TalentTreeCareerSkill do
  menu :parent => "Careers"
  
  index do
    column :talent_tree_id do |tree|
      TalentTree.find_by_id(tree.talent_tree_id).name
    end
    column :skill_id do |skill|
      Skill.find_by_id(skill.skill_id).name
    end
    
    default_actions
  end

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_talent_tree_career_skills_url }
       end
     end
   end
  
end
