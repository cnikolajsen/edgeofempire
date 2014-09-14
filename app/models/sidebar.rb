class Sidebar < ActiveRecord::Base
  validates :title, presence: true, uniqueness: true

  include FriendlyId
  friendly_id :slug_candidates, :use => :slugged

  def slug_candidates
    [
      :title,
    ]
  end

end
