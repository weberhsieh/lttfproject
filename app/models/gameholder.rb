class Gameholder < ActiveRecord::Base
before_save :default_values
  attr_accessible :address, :city, :county, :court_name, :lat, :lng, :name, :phone, :sponsor, :user_id, :zipcode , :approved
  belongs_to :user
  scope :waitingforapprove, where( :approved => false )
  scope :alreadyapproved, where( :approved => true )
def default_values
	self.approved=false
end	
end
