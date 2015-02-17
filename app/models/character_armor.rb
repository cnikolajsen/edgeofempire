class CharacterArmor < ActiveRecord::Base
  belongs_to :character
  belongs_to :armor

  has_many :character_armor_attachments, :dependent => :destroy
  has_many :armor_attachments, :through => :character_armor_attachments
  belongs_to :armor_model
  accepts_nested_attributes_for :character_armor_attachments, :reject_if => :all_blank, :allow_destroy => true

  def total_value
    if armor_attachments.any?
      armor_attachments.each do |attachment|
        armor.price += attachment.price
      end
    end
    armor.price
  end
end
