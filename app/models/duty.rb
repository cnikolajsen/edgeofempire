class Duty < ActiveRecord::Base
  has_many :character_duties
  has_many :characters, :through => :character_duties
  belongs_to :career

  validates :name, presence: true, uniqueness: true

end
