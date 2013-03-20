class TalentTreeCareerSkill < ActiveRecord::Base
  attr_accessible :skill_id, :talent_tree_id
  
  belongs_to :skill
  belongs_to :talent_tree
end
