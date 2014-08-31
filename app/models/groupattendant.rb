class Groupattendant < ActiveRecord::Base
  attr_accessible :attendee, :gamegroup_id, :phone, :registor_id, :regtype, :teamname
  belongs_to :gamegroup
  has_many :attendants
  default_scope order('id ASC')
  def playerlist 
      binding.pry
  	  @playerlist=self.attendants
      @playerlist
  end	

  def findplayer(player_id)
      binding.pry
   	  if self.playerlist.find_all{|v| v.player_id==player_id}
   	    return true
   	  else
   	  	return false 
   	  end	
  end	


end
