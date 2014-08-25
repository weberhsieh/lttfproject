class Gamegroup < ActiveRecord::Base
  attr_accessible :gamefee, :groupname, :grouptype, :holdgame_id, :noofbackupplayers, :noofplayers, :scorehigh, :scorelimitation, :scorelow, :starttime
  belongs_to :holdgame
end
