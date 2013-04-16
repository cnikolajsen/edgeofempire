ActiveAdmin.register TalentTree do
  menu :parent => "Careers"

  index do
    column :name
    column :career_id do |career|
      Career.find_by_id(career.career_id).name unless !career.career_id
    end
    column :description do |desc|
      truncate(desc.description)
    end
    default_actions
  end

  form do |f|
    f.inputs "Talent Tree Details" do
      f.input :name
      f.input :description
      f.input :career_id, :as => :select, :collection => Career.all

      f.input :talent_1_1, :as => :select, :collection => Talent.all, :label => "Column 1 row 1"
      f.input :talent_2_1, :as => :select, :collection => Talent.all, :label => "Column 1 row 2"
      f.input :talent_2_1_require_1_1, :as => :boolean, :label => "Link row 2 with row 1"
      f.input :talent_2_1_require_2_2, :as => :boolean, :label => "Link row 2 right"
      f.input :talent_3_1, :as => :select, :collection => Talent.all, :label => "Column 1 row 3"
      f.input :talent_3_1_require_2_1, :as => :boolean, :label => "Link row 3 with row 2"
      f.input :talent_3_1_require_3_2, :as => :boolean, :label => "Link row 3 right"
      f.input :talent_4_1, :as => :select, :collection => Talent.all, :label => "Column 1 row 4"
      f.input :talent_4_1_require_3_1, :as => :boolean, :label => "Link row 4 with row 3"
      f.input :talent_4_1_require_4_2, :as => :boolean, :label => "Link row 4 right"
      f.input :talent_5_1, :as => :select, :collection => Talent.all, :label => "Column 1 row 5"
      f.input :talent_5_1_require_4_1, :as => :boolean, :label => "Link row 5 with row 4"
      f.input :talent_5_1_require_5_2, :as => :boolean, :label => "Link row 5 right"

      f.input :talent_1_2, :as => :select, :collection => Talent.all, :label => "Column 2 row 1"
      f.input :talent_2_2, :as => :select, :collection => Talent.all, :label => "Column 2 row 2"
      f.input :talent_2_2_require_1_2, :as => :boolean, :label => "Link row 2 with row 1"
      f.input :talent_2_2_require_2_3, :as => :boolean, :label => "Link row 2 right"
      f.input :talent_3_2, :as => :select, :collection => Talent.all, :label => "Column 2 row 3"
      f.input :talent_3_2_require_2_2, :as => :boolean, :label => "Link row 3 with row 2"
      f.input :talent_3_2_require_3_3, :as => :boolean, :label => "Link row 3 right"
      f.input :talent_4_2, :as => :select, :collection => Talent.all, :label => "Column 2 row 4"
      f.input :talent_4_2_require_3_2, :as => :boolean, :label => "Link row 4 with row 3"
      f.input :talent_4_2_require_4_3, :as => :boolean, :label => "Link row 4 right"
      f.input :talent_5_2, :as => :select, :collection => Talent.all, :label => "Column 2 row 5"
      f.input :talent_5_2_require_4_2, :as => :boolean, :label => "Link row 5 with row 4"
      f.input :talent_5_2_require_5_3, :as => :boolean, :label => "Link row 5 right"

      f.input :talent_1_3, :as => :select, :collection => Talent.all, :label => "Column 3 row 1"
      f.input :talent_2_3, :as => :select, :collection => Talent.all, :label => "Column 3 row 2"
      f.input :talent_2_3_require_1_3, :as => :boolean, :label => "Link row 2 with row 1"
      f.input :talent_2_3_require_2_4, :as => :boolean, :label => "Link row 2 right"
      f.input :talent_3_3, :as => :select, :collection => Talent.all, :label => "Column 3 row 3"
      f.input :talent_3_3_require_2_3, :as => :boolean, :label => "Link row 3 with row 2"
      f.input :talent_3_3_require_3_4, :as => :boolean, :label => "Link row 3 right"
      f.input :talent_4_3, :as => :select, :collection => Talent.all, :label => "Column 3 row 4"
      f.input :talent_4_3_require_3_3, :as => :boolean, :label => "Link row 4 with row 3"
      f.input :talent_4_3_require_4_4, :as => :boolean, :label => "Link row 4 right"
      f.input :talent_5_3, :as => :select, :collection => Talent.all, :label => "Column 3 row 5"
      f.input :talent_5_3_require_4_3, :as => :boolean, :label => "Link row 5 with row 4"
      f.input :talent_5_3_require_5_4, :as => :boolean, :label => "Link row 5 right"

      f.input :talent_1_4, :as => :select, :collection => Talent.all, :label => "Column 4 row 1"
      f.input :talent_2_4, :as => :select, :collection => Talent.all, :label => "Column 4 row 2"
      f.input :talent_2_4_require_1_4, :as => :boolean, :label => "Link row 2 with row 1"
      f.input :talent_3_4, :as => :select, :collection => Talent.all, :label => "Column 4 row 3"
      f.input :talent_3_4_require_2_4, :as => :boolean, :label => "Link row 3 with row 2"
      f.input :talent_4_4, :as => :select, :collection => Talent.all, :label => "Column 4 row 4"
      f.input :talent_4_4_require_3_4, :as => :boolean, :label => "Link row 4 with row 3"
      f.input :talent_5_4, :as => :select, :collection => Talent.all, :label => "Column 4 row 5"
      f.input :talent_5_4_require_4_4, :as => :boolean, :label => "Link row 5 with row 4"

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

    table '', :class => 'talent-tree' do
      colgroup do
        col :width => "22%"
        col :width => "4%"
        col :width => "22%"
        col :width => "4%"
        col :width => "22%"
        col :width => "4%"
        col :width => "22%"
      end
      tr do
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_1_1).name unless !talent_tree.talent_1_1
        end
        td
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_1_2).name unless !talent_tree.talent_1_2
        end
        td
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_1_3).name unless !talent_tree.talent_1_3
        end
        td
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_1_4).name unless !talent_tree.talent_1_4
        end
      end
      tr do
        td '', :class => 'vertical-link link-' + talent_tree.talent_2_1_require_1_1.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_2_2_require_1_2.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_2_3_require_1_3.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_2_4_require_1_4.to_s
      end
      tr do
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_2_1).name unless !talent_tree.talent_2_1
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_2_1_require_2_2.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_2_2).name unless !talent_tree.talent_2_2
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_2_2_require_2_3.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_2_3).name unless !talent_tree.talent_2_3
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_2_3_require_2_4.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_2_4).name unless !talent_tree.talent_2_4
        end
      end
      tr do
        td '', :class => 'vertical-link link-' + talent_tree.talent_3_1_require_2_1.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_3_2_require_2_2.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_3_3_require_2_3.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_3_4_require_2_4.to_s
      end
      tr do
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_3_1).name unless !talent_tree.talent_3_1
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_3_1_require_3_2.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_3_2).name unless !talent_tree.talent_3_2
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_3_2_require_3_3.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_3_3).name unless !talent_tree.talent_3_3
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_3_3_require_3_4.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_3_4).name unless !talent_tree.talent_3_4
        end
      end
      tr do
        td '', :class => 'vertical-link link-' + talent_tree.talent_4_1_require_3_1.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_4_2_require_3_2.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_4_3_require_3_3.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_4_4_require_3_4.to_s
      end
      tr do
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_4_1).name unless !talent_tree.talent_4_1
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_4_1_require_4_2.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_4_2).name unless !talent_tree.talent_4_2
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_4_2_require_4_3.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_4_3).name unless !talent_tree.talent_4_3
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_4_3_require_4_4.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_4_4).name unless !talent_tree.talent_4_4
        end
      end
      tr do
        td '', :class => 'vertical-link link-' + talent_tree.talent_5_1_require_4_1.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_5_2_require_4_2.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_5_3_require_4_3.to_s
        td
        td '', :class => 'vertical-link link-' + talent_tree.talent_5_4_require_4_4.to_s
      end
      tr do
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_5_1).name unless !talent_tree.talent_5_1
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_5_1_require_5_2.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_5_2).name unless !talent_tree.talent_5_2
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_5_2_require_5_3.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_5_3).name unless !talent_tree.talent_5_3
        end
        td '', :class => 'horizontal-link link-' + talent_tree.talent_5_3_require_5_4.to_s
        td :class => 'talent' do
          Talent.find_by_id(talent_tree.talent_5_4).name unless !talent_tree.talent_5_4
        end
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
