class Holdgame < ActiveRecord::Base
  attr_accessible :enddate, :gameholder_id, :gamename, :gamenote, :gametype, :startdate 
  attr_accessible :city, :county, :address, :zipcode, :courtname, :lat, :lng
  belongs_to :gameholder
  has_many :gamegroups , dependent: :destroy
  after_commit :assign_informs_from_holder
  def assign_informs_from_holder
  	self.city=self.gameholder.city 
  	self.county=self.gameholder.county 
  	self.address=self.gameholder.address 
  	self.courtname=self.gameholder.courtname
  	self.zipcode=self.gameholder.zipcode
  	self.lat=self.gameholder.lat
    self.lng=self.gameholder.lng
  	self.save
  end	
end
