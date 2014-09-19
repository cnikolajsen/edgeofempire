class Gear < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, :use => :slugged

  default_scope { order('gears.name ASC') }

  has_many :gear_models
  belongs_to :gear_category
  accepts_nested_attributes_for :gear_models, :reject_if => :all_blank, :allow_destroy => true
end
