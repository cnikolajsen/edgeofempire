class CharacterCybernetic < ActiveRecord::Base
  belongs_to :character
  belongs_to :gear

  def cyberneticarmv
    traits = {
      :brawn => 1
    }
    traits
  end

  def cyberneticarmvi
    traits = {
      :agility => 1
    }
    traits
  end

  def cyberneticlegii
    traits = {
      :brawn => 1
    }
    traits
  end

  def cyberneticlegiii
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
