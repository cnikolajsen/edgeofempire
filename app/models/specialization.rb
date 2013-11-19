class Specialization < ActiveRecord::Base
  has_many :talents
  belongs_to :career
end
