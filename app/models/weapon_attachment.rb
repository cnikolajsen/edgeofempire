class WeaponAttachment < ActiveRecord::Base
  has_many :weapon_attachments_weapons

  has_many :weapon_qualities, :through => :weapon_attachment_quality_ranks
  has_many :weapon_attachment_quality_ranks
  accepts_nested_attributes_for :weapon_attachment_quality_ranks, :reject_if => :all_blank, :allow_destroy => true
  has_many :weapon_attachment_modification_options
  accepts_nested_attributes_for :weapon_attachment_modification_options, :reject_if => :all_blank, :allow_destroy => true

  #has_many :weapon_attachment_attachments_groups
  #has_many :attachment_groups, :through => :weapon_attachment_attachments_groups
  #accepts_nested_attributes_for :weapon_attachment_attachments_groups, :reject_if => :all_blank, :allow_destroy => true
  validates :name, presence: true, uniqueness: true

end
