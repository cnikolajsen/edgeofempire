class CharacterTalent < ActiveRecord::Base
  #attr_accessible :character_id, :talent_id, :talent_tree_id
  
  serialize :talent_1_1_options, JSON
  serialize :talent_1_2_options, JSON
  serialize :talent_1_3_options, JSON
  serialize :talent_1_4_options, JSON
  serialize :talent_2_1_options, JSON
  serialize :talent_2_2_options, JSON
  serialize :talent_2_3_options, JSON
  serialize :talent_2_4_options, JSON
  serialize :talent_3_1_options, JSON
  serialize :talent_3_2_options, JSON
  serialize :talent_3_3_options, JSON
  serialize :talent_3_4_options, JSON
  serialize :talent_4_1_options, JSON
  serialize :talent_4_2_options, JSON
  serialize :talent_4_3_options, JSON
  serialize :talent_4_4_options, JSON
  serialize :talent_5_1_options, JSON
  serialize :talent_5_2_options, JSON
  serialize :talent_5_3_options, JSON
  serialize :talent_5_4_options, JSON

  belongs_to :character
  belongs_to :talent
end
