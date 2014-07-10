class ArmorAttachment < ActiveRecord::Base
    has_many :armor_qualities, :through => :armor_quality_ranks
    has_many :armor_quality_ranks
    accepts_nested_attributes_for :armor_quality_ranks
    has_many :armor_attachment_modification_options
    accepts_nested_attributes_for :armor_attachment_modification_options
    has_many :armor_attachments_armors

    #has_many :armor_attachment_attachments_groups
    #has_many :attachment_groups, :through => :armor_attachment_attachments_groups
    #accepts_nested_attributes_for :armor_attachment_attachments_groups, :reject_if => :all_blank, :allow_destroy => true
end
