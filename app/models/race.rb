class Race < ActiveRecord::Base
  #attr_accessible :agility, :brawn, :cunning, :description, :intellect, :name, :presence, :special_ability, :starting_experience, :strain_threshold, :willpower, :wound_threshold

  default_scope { order('name ASC') }

end
