# encoding: UTF-8”
class Gamegroup < ActiveRecord::Base
  attr_accessible :gamefee, :groupname, :grouptype, :holdgame_id, :noofbackupplayers, :noofplayers, :scorehigh
  attr_accessible :scorelimitation, :scorelow, :starttime , :regtype
  belongs_to :holdgame
  has_many :groupattendants
  default_scope order('id ASC')
  def self.regtypes
   {'single'=>'個人', 'double'=>'雙人', 'team'=>'團體'}
  end
  def find_player_in_attendants(player_id)
  	self.groupattendants.each do |attendee|
  	  if attendee.findplayer(player_id)
  	    return attendee.id 
  	  end 	
  	end	
  	return nil
  end
  def check_meet_group_qualify(player_curscore)
  	case self.scorelimitation
      when '無積分限制'
         return true
      when '限制高低分'
       return( (player_curscore >= self.scorelow) &&
                                        (player_curscore<=self.scorehigh) )
      when '限制最高分'
         return (player_curscore<=self.scorehigh) 
      when '限制最低分'                                    
        return (player_curscore>=self.scorelow) 
    end	
  end

end
