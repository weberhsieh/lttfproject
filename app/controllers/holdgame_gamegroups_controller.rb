# encoding: UTF-8”
class HoldgameGamegroupsController < ApplicationController
  layout :resolve_layout
	before_filter :find_holdgame

def index

  @gamegroups = @holdgame.gamegroups
  if !params[:targroupid]
    @targetgroup_id=@gamegroups.first.id
   
    #@gamegroup=@holdgame.gamegroups.first
  else
    @targetgroup_id=params[:targroupid].to_i
  end  
 binding.pry
  @attendee=create_attendee_array(@gamegroups)
  
  @user_meet_groups=check_user_meetgroupqualify(@gamegroups,current_user.id)
  #@user_registered=check_user_registered(current_user.id,@attendee)

end
def create_attendee_array(gamegroups)
  @attendee_array=Hash.new
  @user_in_groups=Hash.new
  gamegroups.each do |gamegroup|
    @group_attendee_array=Array.new
    #@attendee_array.push(expand_attendee(gamegroup.id,gamegroup.regtype,gamegroup.groupattendants))
    if(!gamegroup.groupattendants.empty? )
       
        gamegroup.groupattendants.each do |attendant|
          @temp=attendant.playerlist
          @group_attendee_array.push(@temp)
     
          user_in_group=@temp.find_all{|v|v['user_id']==current_user.id}
          if(!user_in_group.empty?)
            @user_in_groups[gamegroup.id]=attendant.id
          else
            @user_in_groups[gamegroup.id]=nil
          end  
       
      end  
    end

    #@attendee_array.push(@group_attendee_array)
    @attendee_array[gamegroup.id]=@group_attendee_array
  end

  @attendee_array
end

def check_user_meetgroupqualify(gamegroups, player_id)
  user_meet_groups=Hash.new
  player=User.find(player_id)

  gamegroups.each do |gamegroup|
 
    user_meet_groups[gamegroup.id]=gamegroup.check_meet_group_qualify(player.playerprofile.curscore)
  end  
  return user_meet_groups
end


def expand_attendee(groupid,regtype,groupattendee)
  
  @attendee=Array.new
  if groupattendee!=[] 
    case regtype
      when "single"
        groupattendee.each do |player|
        attendant=Hash.new
        attendant['phone']=player.phone
        attendant['registor']=player.registor_id
        temp1=player.attendee.split(')')
        dummy,attendant['user_id'],attendant['name'],attendant['email'],attendant['pos']=temp1[0].split(',')
        attendant['user_id']=attendant['user_id'].to_i
        if attendant['user_id']==current_user.id
          @user_in_groups[groupid]=player.id
        else
         
          @user_in_groups[groupid]=nil
        end  

        user=User.find(attendant['user_id'])
        attendant['curscore']=user.playerprofile.curscore 
        attendant['email']=user.email
        attendant['id']=player.id
        @attendee.push(attendant) 
      end
    
      when "double"
    
      when "team"  
      end    
  else
     attendant=Hash.new
     @attendee.push(attendant) 
  end  
   
   @attendee 
end
def registration

     @curgroup=Gamegroup.find(params[:format])
     attendant=@curgroup.groupattendants.build
    
     Groupattendant.transaction do
     
     attendant.regtype= @curgroup.regtype
     attendant.attendee='(,'+current_user.id.to_s+','+current_user.username+','+current_user.email+','+''+')'
     attendant.phone=current_user.phone
     attendant.registor_id=current_user.id
     attendant.save 
   end 

    #@gamegroups = @holdgame.gamegroups
    #@attendee=create_attendee_array(@gamegroups)
    #@targettabindex=@gamegroups.index(@curgroup)+1
    
    redirect_to  holdgame_gamegroups_path(@holdgame, {:targroupid=>@curgroup.id})
end  
def singlegroupregistration
  binding.pry
  @curgroup=Gamegroup.find(params[:format])
  attendant=@curgroup.groupattendants.build
  @playerlist=Array.new
  @playerlist=User.find(params[:playerid]) if params[:playerid]
  binding.pry
  Groupattendant.transaction do
     
    attendant.regtype= @curgroup.regtype
    attendant.attendee='(,'+current_user.id.to_s+','+current_user.username+','+current_user.email+','+''+')'
    attendant.phone=current_user.phone
    attendant.registor_id=current_user.id
    attendant.attendee=''
    @playerlist.each do |player|
      attendant.attendee+='(,'+player.id.to_s+','+player.username+','+player.email+','+''+')'
      binding.pry
    end 
    binding.pry
    attendant.save 
  end 

    #@gamegroups = @holdgame.gamegroups
    #@attendee=create_attendee_array(@gamegroups)
    #@targettabindex=@gamegroups.index(@curgroup)+1
    
    redirect_to  holdgame_gamegroups_path(@holdgame, {:targroupid=>@curgroup.id})
end  
def cancel_current_user_registration
  binding.pry
  @attendant=Groupattendant.find(params[:user_in_groupattendant])
  @curgroup=@attendant.gamegroup
  @attendant.destroy
  @gamegroups = @holdgame.gamegroups
  @attendee=create_attendee_array(@gamegroups)
  @targettabindex=@gamegroups.index(@curgroup)+1
    
  redirect_to  holdgame_gamegroups_path(@holdgame, {:targroupid=>@curgroup.id})

end 
def copy_players_from_tags(playeridlist,playernamelist,playercurscorelist)
   
end 
def playerinput

    gamegroupid=params[:format]
    reg = /^\d+$/
    @playerlist=Array.new
    @playerlist=User.find(params[:playerid]) if params[:playerid]
    if(params[:keyword])
          
      if ! reg.match(params[:keyword])
        @newplayer = User.where(:username=>params[:keyword]).first

      else
        @newplayer=User.find(params[:keyword].to_i)  
      end  
             
      @playerlist.push(@newplayer) if @newplayer
      
    end  
  
    
end
def singleplayerinput

    @curgamegroupid=params[:format]
    reg = /^\d+$/
    @playerlist=Array.new
    @playerlist=User.find(params[:playerid]) if params[:playerid]
    if(params[:keyword])
          
      if ! reg.match(params[:keyword])
        @newplayer = User.where(:username=>params[:keyword]).first

      else
        @newplayer=User.find(params[:keyword].to_i)  
      end  
             
      @playerlist.push(@newplayer) if @newplayer
      
    end  
  
    
end
def show
  binding.pry
  @gamegroup = @holdgame.gamegroups.find( params[:id] )
  @groupttendee= @gamegroup.groupttendants
  @attendee =expand_attendee(@gamegroup.regtype,@groupttendee)
end

def new
 
  @gamegroup = @holdgame.gamegroups.build
 
end

def create
  @gamegroup = @holdgame.gamegroups.build( params[:gamegroup] )
  if @gamegroup.save
#    redirect_to holdgame_gamegroups_url( @holdgame )
   
     redirect_to  holdgame_gamegroups_path(@holdgame, {:targroupid=>@gamegroup.id}) 
  else
    render :action => :new
  end
end

def edit

  
  @gamegroup = @holdgame.gamegroups.find( params[:id] )
end

def update
  @gamegroup = @holdgame.gamegroups.find( params[:id] )

  if @gamegroup.update_attributes( params[:gamegroup] )
    redirect_to  holdgame_gamegroups_path(@holdgame, {:targroupid=>@gamegroup.id}) 
  else
    render :action => :new
  end

end

def destroy
  @gamegroup = @holdgame.gamegroups.find( params[:id] )
  @gamegroup.groupattendants.delete_all
  @gamegroup.destroy

  redirect_to holdgame_gamegroups_url( @holdgame )
end

protected

def find_holdgame
  @holdgame = Holdgame.find( params[:holdgame_id] )
  @gameholder=Gameholder.find( @holdgame.gameholder_id)
  gon.lat=@gameholder.lat
  gon.lng=@gameholder.lng
  gon.courtname=@gameholder.courtname+'--['+@gameholder.address+']'
end
def resolve_layout
    case action_name
    
    when "index" 
      "gamegroup"
    else
      "application"
    end
  end
end
