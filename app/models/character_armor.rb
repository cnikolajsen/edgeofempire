class CharacterArmor < ActiveRecord::Base
  belongs_to :character
  belongs_to :armor

  has_many :character_armor_attachments, :dependent => :destroy
  has_many :armor_attachments, :through => :character_armor_attachments
  accepts_nested_attributes_for :character_armor_attachments, :reject_if => :all_blank, :allow_destroy => true
end
