class ForcePowerUpgrade < ActiveRecord::Base
  belongs_to :force_power

  default_scope { order('row ASC').order('"column" ASC') }
end
