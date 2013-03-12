class Campaign < ActiveRecord::Base
  attr_accessible :description, :name, :user_id
  
  validates_presence_of :name, :message => "can't be blank"
    
  belongs_to :user
  has_many :adventures, :dependent => :destroy
  
end
