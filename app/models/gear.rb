class Gear < ActiveRecord::Base
  default_scope { order('name ASC') }

  has_many :gear_models
  accepts_nested_attributes_for :gear_models, :reject_if => :all_blank, :allow_destroy => true
end
