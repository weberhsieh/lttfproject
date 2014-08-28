class Groupattendant < ActiveRecord::Base
  attr_accessible :attendee, :gamegroup_id, :phone, :registor_id, :regtype, :teamname
  belongs_to :gamegroup
  default_scope order('id ASC')
  def playerlist ()
  	@playerlist=Array.new
    temp1=self.attendee.split(')')
    temp1.each do |temp|
      attendant=Hash.new
      attendant['phone']=self.phone
      attendant['registor']=self.registor_id
      dummy,attendant['user_id'],attendant['name'],attendant['email'],attendant['pos']=temp.split(',')
      attendant['user_id']=attendant['user_id'].to_i
      user=User.find(attendant['user_id'])
      attendant['curscore']=user.playerprofile.curscore 
      attendant['email']=user.email
      attendant['id']=self.id
      attendant['group_id']=self.gamegroup.id
      @playerlist.push(attendant) 
  
    end
    @playerlist
  end	

   def findplayer(player_id)
   	  if self.playerlist.find_all{|v| v['user_id']==player_id}
   	    return true
   	  else
   	  	return false 
   	  end	
   end	

end
