class CharacterCybernetic < ActiveRecord::Base
  belongs_to :character
  belongs_to :gear

  def cyberneticarmmodv
    traits = {
      brawn: 1
    }
    traits
  end

  def cyberneticarmmodvi
    traits = {
      agility: 1
    }
    traits
  end

  def cyberneticlegmodii
    traits = {
      brawn: 1
    }
    traits
  end

  def cyberneticlegmodiii
    traits = {
      :agility => 1
    }
    traits
  end

  def cyberneticbrainimplant
    traits = {
      :intellect => 1
    }
    traits
  end

  def cyberneticeyes
    traits = {
      :vigilance => 1,
      :perception => 1
    }
    traits
  end

  def implantarmor
    traits = {
      :soak => 1
    }
    traits
  end

end
