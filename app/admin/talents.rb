ActiveAdmin.register Talent do
  menu :parent => "Careers"

  config.sort_order = "name_asc"

  index do
    column :name
    column :description do |desc|
      #text_replace_tokens(desc.description.gsub("\n", "<br />")).html_safe
      truncate(desc.description)
    end
    column :activation
    column :ranked
    default_actions
  end
  
  show do
    div do
      strong "Activation: #{talent.activation}"
    end
    div do
      simple_format text_replace_tokens(talent.description)
    end
    div do
      trees = TalentTree.find(:all, :conditions => ['talent_1_1 = :talent OR talent_1_2 = :talent OR talent_1_3 = :talent OR talent_1_4 = :talent OR talent_2_1 = :talent OR talent_2_2 = :talent OR talent_2_3 = :talent OR talent_2_4 = :talent OR talent_3_1 = :talent OR talent_3_2 = :talent OR talent_3_3 = :talent OR talent_3_4 = :talent OR talent_4_1 = :talent OR talent_4_2 = :talent OR talent_4_3 = :talent OR talent_4_4 = :talent OR talent_5_1 = :talent OR talent_5_2 = :talent OR talent_5_3 = :talent OR talent_5_4 = :talent', {:talent => "#{talent.id}"}])
      #trees.inspect
      used_in_trees = Array.new
      trees.each do |tree|
        used_in_trees << link_to(tree.name, admin_talent_tree_path(tree.id))
        #span tree.name
      end
      strong "Talent Trees: #{used_in_trees.join(', ')}".html_safe
    end
  end

  filter :name
  filter :ranked
  filter :activation, :as => :select, :collection => proc { ['Active (Incidental)', 'Active (Action)', 'Active (Maneuver)', 'Passive'] }

  controller do
     def create
       create! do |format|
          format.html { redirect_to admin_talents_url }
       end
     end
   end
end
