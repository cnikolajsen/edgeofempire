class AdversaryWeapon < ActiveRecord::Base
  belongs_to :adversary
  belongs_to :weapon

  has_many :adversary_weapon_attachments, dependent: :destroy
  has_many :weapon_attachments, through: :adversary_weapon_attachments
  accepts_nested_attributes_for :adversary_weapon_attachments, reject_if: :all_blank, allow_destroy: true
end
