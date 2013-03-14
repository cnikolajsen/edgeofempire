class Weapon < ActiveRecord::Base
  attr_accessible :crit, :damage, :description, :name, :price, :skill_id
end
