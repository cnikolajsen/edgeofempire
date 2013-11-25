class RaceTalent < ActiveRecord::Base
  belongs_to :race
  belongs_to :talent
end
