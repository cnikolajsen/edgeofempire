class RaceSkill < ActiveRecord::Base
  belongs_to :race
  belongs_to :skill
end
