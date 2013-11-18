class TalentTree < ActiveRecord::Base
  #attr_accessible :description, :name, :career_id, :talent_1_1, :talent_1_2, :talent_1_3, :talent_1_4, :talent_2_1, :talent_2_2, :talent_2_3, :talent_2_4, :talent_3_1, :talent_3_2, :talent_3_3, :talent_3_3, :talent_3_4, :talent_4_1, :talent_4_2, :talent_4_3, :talent_4_4, :talent_4_4, :talent_2_1_require_1_1, :talent_2_1_require_2_2, :talent_2_2_require_1_2, :talent_2_2_require_2_3, :talent_2_3_require_1_3, :talent_2_3_require_2_4, :talent_2_4_require_1_4, :talent_3_1_require_2_1, :talent_3_1_require_3_2, :talent_3_2_require_2_2, :talent_3_2_require_3_3, :talent_3_3_require_2_3, :talent_3_3_require_3_4, :talent_3_4_require_2_4, :talent_4_1_require_3_1, :talent_4_1_require_4_2, :talent_4_2_require_3_2, :talent_4_2_require_4_3, :talent_4_3_require_3_3, :talent_4_3_require_4_4, :talent_4_4_require_3_4, :talent_5_1, :talent_5_1_require_4_1, :talent_5_1_require_5_2, :talent_5_2, :talent_5_2_require_4_2, :talent_5_2_require_5_3, :talent_5_3, :talent_5_3_require_4_3, :talent_5_3_require_5_4, :talent_5_4, :talent_5_4_require_4_4, :talent_tree_career_skills_attributes
  
  belongs_to :career
  has_many :talent_tree_career_skills
  has_many :skills, :through => :talent_tree_career_skills
  accepts_nested_attributes_for :talent_tree_career_skills

  default_scope { order('name ASC') }

end
