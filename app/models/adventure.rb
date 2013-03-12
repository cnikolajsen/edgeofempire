class Adventure < ActiveRecord::Base
  attr_accessible :campaign_id, :description, :name
  
  belongs_to :campaign
end
