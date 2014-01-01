class ArmorAttachment < ActiveRecord::Base
    has_many :armor_qualities, :through => :armor_quality_ranks
    has_many :armor_quality_ranks
    accepts_nested_attributes_for :armor_quality_ranks
    has_many :armor_attachment_modification_options
    accepts_nested_attributes_for :armor_attachment_modification_options
end
