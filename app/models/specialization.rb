class Specialization < ActiveRecord::Base
  attr_accessible :description, :name, :career_id

  has_many :talents
  belongs_to :career
end
