ActiveAdmin.register TalentTree do
  menu :parent => "Careers"

  form do |f|
    f.inputs "Talent Tree Details" do
      f.input :name
      f.input :description
      f.input :talent_1_1, :as => :select, :collection => Talent.all
      f.input :talent_1_2, :as => :select, :collection => Talent.all
      f.input :talent_1_3, :as => :select, :collection => Talent.all
      f.input :talent_1_4, :as => :select, :collection => Talent.all
      f.input :talent_2_1, :as => :select, :collection => Talent.all
      f.input :talent_2_2, :as => :select, :collection => Talent.all
      f.input :talent_2_3, :as => :select, :collection => Talent.all
      f.input :talent_2_4, :as => :select, :collection => Talent.all
      f.input :talent_3_1, :as => :select, :collection => Talent.all
      f.input :talent_3_2, :as => :select, :collection => Talent.all
      f.input :talent_3_3, :as => :select, :collection => Talent.all
      f.input :talent_3_4, :as => :select, :collection => Talent.all
      f.input :talent_4_1, :as => :select, :collection => Talent.all
      f.input :talent_4_2, :as => :select, :collection => Talent.all
      f.input :talent_4_3, :as => :select, :collection => Talent.all
      f.input :talent_4_4, :as => :select, :collection => Talent.all
      f.has_many :talent_tree_career_skills do |skill_form|
        skill_form.input :skill_id, :as => :select, :collection => Skill.all
      end

    end

    f.actions
  end
  
  show :title => :name do
    div talent_tree.description
    
    div do
      strong "Career Skills: "
      render "talent_tree_career_skills", :skills => talent_tree.talent_tree_career_skills
    end
    
    table do
      tr do
        td Talent.find_by_id(talent_tree.talent_1_1).name unless !talent_tree.talent_1_1
        td Talent.find_by_id(talent_tree.talent_1_2).name unless !talent_tree.talent_1_2
        td Talent.find_by_id(talent_tree.talent_1_3).name unless !talent_tree.talent_1_3
        td Talent.find_by_id(talent_tree.talent_1_4).name unless !talent_tree.talent_1_4
      end
      tr do
        td Talent.find_by_id(talent_tree.talent_2_1).name unless !talent_tree.talent_2_1
        td Talent.find_by_id(talent_tree.talent_2_2).name unless !talent_tree.talent_2_2
        td Talent.find_by_id(talent_tree.talent_2_3).name unless !talent_tree.talent_2_3
        td Talent.find_by_id(talent_tree.talent_2_4).name unless !talent_tree.talent_2_4
      end
      tr do
        td Talent.find_by_id(talent_tree.talent_3_1).name unless !talent_tree.talent_3_1
        td Talent.find_by_id(talent_tree.talent_3_2).name unless !talent_tree.talent_3_2
        td Talent.find_by_id(talent_tree.talent_3_3).name unless !talent_tree.talent_3_3
        td Talent.find_by_id(talent_tree.talent_3_4).name unless !talent_tree.talent_3_4
      end
      tr do
        td Talent.find_by_id(talent_tree.talent_4_1).name unless !talent_tree.talent_4_1
        td Talent.find_by_id(talent_tree.talent_4_2).name unless !talent_tree.talent_4_2
        td Talent.find_by_id(talent_tree.talent_4_3).name unless !talent_tree.talent_4_3
        td Talent.find_by_id(talent_tree.talent_4_4).name unless !talent_tree.talent_4_4
      end
    end
  end

  controller do
    def create
      create! do |format|
        format.html { redirect_to admin_talent_trees_url }
      end
    end
  end

end
