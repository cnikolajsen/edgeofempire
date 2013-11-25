class Race < ActiveRecord::Base
  default_scope { order('name ASC') }

  has_many :race_skills, :dependent => :destroy
  has_many :skills, :through => :race_skills
  accepts_nested_attributes_for :race_skills, :reject_if => :all_blank, :allow_destroy => true
  has_many :race_talents, :dependent => :destroy
  has_many :talents, :through => :race_talents
  accepts_nested_attributes_for :race_talents, :reject_if => :all_blank, :allow_destroy => true
  
end
