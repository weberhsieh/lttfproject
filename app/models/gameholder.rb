class Gameholder < ActiveRecord::Base
  attr_accessible :address, :approved, :city, :county, :courtname, :email, :lat, :lng, :name, :phone, :sponsor, :user_id, :zipcode

  scope :waitingforapprove, where( :approved => false )
  scope :alreadyapproved, where( :approved => true )
  belongs_to :user
  has_many :holdgames
end
