class ForcePower < ActiveRecord::Base
  include FriendlyId
  friendly_id :name, :use => :slugged

  def should_generate_new_friendly_id?
    name_changed?
  end

  default_scope { order('name ASC') }

  has_many :force_power_upgrades
  accepts_nested_attributes_for :force_power_upgrades, :reject_if => :all_blank, :allow_destroy => true

  def upgrade_links_vertical_admin
    if self.name == 'Influence'
      links = [ [], [1,0,1,0,0,0,1], [1,0,1,0,0,0,1], [1,0,1,0,1,0,1] ]
    elsif self.name == 'Move'
      links = [ [], [1,0,1,0,1,0,1], [1,0,1,0,1,0,1], [1,0,1,0,1,0,1] ]
    elsif self.name == 'Sense'
      links = [ [], [0,1,0,0,1,0,1], [0,1,0,0,1,0,1], [0,1,0,0,1,0,1] ]
    end
  end

  def upgrade_links_horizontal_admin
    if self.name == 'Influence'
      links = [ [], [], [0,0,1], [0,0,1] ]
    elsif self.name == 'Move'
      links = [ [], [], [], [] ]
    elsif self.name == 'Sense'
      links = [ [], [], [], [] ]
    end
  end

  def upgrade_links_vertical
    if self.name == 'Influence'
      links = [ [0,1,0,0,1,0,0,0,1,0,0,0], [0,1,0,0,1,0,0,0,0,0,1,0], [0,1,0,0,1,0,0,0,0,0,1,0], [0,1,0,0,1,0,0,1,0,0,1,0] ]
    elsif self.name == 'Move'
      links = [ [0,1,0,0,1,0,0,1,0,0,1,0], [0,1,0,0,1,0,0,1,0,0,1,0], [0,1,0,0,1,0,0,1,0,0,1,0], [0,1,0,0,1,0,0,1,0,0,1,0] ]
    elsif self.name == 'Sense'
      links = [ [0,0,1,0,0,0,0,0,0,1,0,0], [0,0,1,0,0,0,0,1,0,0,1,0], [0,0,1,0,0,0,0,1,0,0,1,0], [0,0,1,0,0,0,0,1,0,0,1,0] ]
    end
  end

  def upgrade_links_horizontal
    if self.name == 'Influence'
      links = [ [0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0], [0,0,0,0,0,1,1,0], [0,0,0,0,0,1,1,0] ]
    elsif self.name == 'Move'
      links = [ [0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0] ]
    elsif self.name == 'Sense'
      links = [ [0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0], [0,0,0,0,0,0,0,0] ]
    end
  end

end
