class CareerSkill < ActiveRecord::Base
  attr_accessible :career_id, :skill_id
  
  belongs_to :skill
  belongs_to :career
end
