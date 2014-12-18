class TalentTree < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, :use => :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  has_many :career_talent_trees
  has_many :careers, :through => :career_talent_trees
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
