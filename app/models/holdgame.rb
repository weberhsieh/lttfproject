class Holdgame < ActiveRecord::Base
  attr_accessible :enddate, :gameholder_id, :gamename, :gamenote, :gametype, :startdate
  belongs_to :gameholder
  has_many :gamegroups
end
