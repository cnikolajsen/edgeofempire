class WeaponAttachment < ActiveRecord::Base
  has_many :weapon_qualities, :through => :weapon_attachment_quality_ranks
  has_many :weapon_attachment_quality_ranks
  accepts_nested_attributes_for :weapon_attachment_quality_ranks
  has_many :weapon_attachment_modification_options
  accepts_nested_attributes_for :weapon_attachment_modification_options
end
