class CareerTalentTree < ActiveRecord::Base
    belongs_to :talent_tree
    belongs_to :career
end
