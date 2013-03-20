class TalentTree < ActiveRecord::Base
  attr_accessible :description, :name, :talent_1_1, :talent_1_2, :talent_1_3, :talent_1_4, :talent_2_1, :talent_2_2, :talent_2_3, :talent_2_4, :talent_3_1, :talent_3_2, :talent_3_3, :talent_3_3, :talent_3_4, :talent_4_1, :talent_4_2, :talent_4_3, :talent_4_4, :talent_4_4, :talent_tree_career_skills_attributes
  
  has_many :talent_tree_career_skills
  has_many :skills, :through => :talent_tree_career_skills
  accepts_nested_attributes_for :talent_tree_career_skills
end