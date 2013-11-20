class Career < ActiveRecord::Base
  has_many :talent_trees
  has_many :career_skills
  has_many :skills, :through => :career_skills
  accepts_nested_attributes_for :career_skills, :reject_if => :all_blank, :allow_destroy => true

  default_scope { order('name ASC') }

end
