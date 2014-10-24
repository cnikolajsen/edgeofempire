class AdversaryArmor < ActiveRecord::Base
  belongs_to :adversary
  belongs_to :armor

  has_many :adversary_armor_attachments, dependent: :destroy
  has_many :armor_attachments, through: :adversary_armor_attachments
  accepts_nested_attributes_for :adversary_armor_attachments, reject_if: :all_blank, allow_destroy: true
end
