class Gear < ActiveRecord::Base
  #attr_accessible :description, :name, :price

  default_scope { order('name ASC') }

end
