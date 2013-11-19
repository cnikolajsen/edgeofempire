class TalentTree < ActiveRecord::Base
  
  belongs_to :career
  has_many :talent_tree_career_skills
  has_many :skills, :through => :talent_tree_career_skills
  accepts_nested_attributes_for :talent_tree_career_skills

  default_scope { order('name ASC') }

end
