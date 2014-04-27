class TalentTree < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, :use => :slugged

  belongs_to :career
  has_many :talent_tree_career_skills
  has_many :skills, :through => :talent_tree_career_skills
  accepts_nested_attributes_for :talent_tree_career_skills

  default_scope { order('name ASC') }

  # Check if a talent tree is a force tree.
  def force_tree
    force_trees = [ "Force Sensitive Exile" ]

    if force_trees.include? self.name
      true
    else
      false
    end
  end
end
