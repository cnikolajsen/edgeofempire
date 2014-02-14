class CharacterWeapon < ActiveRecord::Base
  belongs_to :character
  belongs_to :weapon

  has_many :character_weapon_attachments, :dependent => :destroy
  has_many :weapon_attachments, :through => :character_weapon_attachments
  belongs_to :weapon_model
  accepts_nested_attributes_for :character_weapon_attachments, :reject_if => :all_blank, :allow_destroy => true
end
