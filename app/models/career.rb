class Career < ActiveRecord::Base
  attr_accessible :description, :name
  
  has_many :specializations
end
