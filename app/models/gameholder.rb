class Gameholder < ActiveRecord::Base
  attr_accessible :address, :city, :county, :court_name, :lat, :lng, :name, :phone, :sponsor, :user_id, :zipcode , :approved
  belongs_to :user
end
