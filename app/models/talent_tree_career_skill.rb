class TalentTreeCareerSkill < ActiveRecord::Base
  belongs_to :skill
  belongs_to :talent_tree
end
