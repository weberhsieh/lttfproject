# encoding: UTF-8”
class HoldgameGamegroupsController < ApplicationController
  layout :resolve_layout
	before_filter :find_holdgame

def index

  @gamegroups = @holdgame.gamegroups
  if !params[:targettab]
    @targettabindex=1
    #@gamegroup=@holdgame.gamegroups.first
  else
    @targettabindex=params[:targettab].to_i
  end  
  @attendee=create_attendee_array(@gamegroups)
  @user_meet_groups=check_user_meetgroupqualify(@gamegroups)
  #@user_registered=check_user_registered(current_user.id,@attendee)

end
def create_attendee_array(gamegroups)
  @attendee_array=Array.new
  @user_in_groups=Hash.new
  gamegroups.each do |gamegroup|
   @attendee_array.push(expand_attendee(gamegroup.id,gamegroup.regtype,gamegroup.groupattendants))
  end
  return @attendee_array
end

def check_user_meetgroupqualify(gamegroups)
  user_meet_groups=Hash.new
  gamegroups.each do |gamegroup|
    case gamegroup.scorelimitation
      when '無積分限制'
         user_meet_groups[gamegroup.id]=true
      when '限制高低分'
        user_meet_groups[gamegroup.id]= (current_user.playerprofile.curscore >= gamegroup.scorelow) &&
                                        (current_user.playerprofile.curscore<=gamegroup.scorehigh) 
      when '限制最高分'
         user_meet_groups[gamegroup.id]= (current_user.playerprofile.curscore<=gamegroup.scorehigh) 
      when '限制最低分'                                    
        user_meet_groups[gamegroup.id]= (current_user.playerprofile.curscore>=gamegroup.scorelow) 
    end
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
     
     @curgroup=Gamegroup.find(params[:gamegroup_id])
     attendant=@curgroup.groupattendants.build
    
     Groupattendant.transaction do
     
     attendant.regtype= @curgroup.regtype
     attendant.attendee='(,'+current_user.id.to_s+','+current_user.username+','+current_user.email+','+'隊長'+')'
     attendant.save 
   end 

    @gamegroups = @holdgame.gamegroups
    @attendee=create_attendee_array(@gamegroups)
    @targettabindex=@gamegroups.index(@curgroup)+1
    
    redirect_to  holdgame_gamegroups_path(@holdgame, {:targettab=> @targettabindex})
end  
def cancel_current_user_registration
  @attendant=Groupattendant.find(params[:user_in_groupattendant])
  @curgroup=@attendant.gamegroup
  @attendant.destroy
  @gamegroups = @holdgame.gamegroups
  @attendee=create_attendee_array(@gamegroups)
  @targettabindex=@gamegroups.index(@curgroup)+1
    
  redirect_to  holdgame_gamegroups_path(@holdgame, {:targettab=> @targettabindex})

end  
def show
 
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
    @gamegroups = @holdgame.gamegroups
    @targettabindex=@gamegroups.index(@gamegroup)+1
    @groupttendee=@gamegroup.groupattendants
    @attendee =Hash.new
    render :index
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
    redirect_to holdgame_gamegroups_url( @holdgame )
  else
    render :action => :new
  end

end

def destroy
  @gamegroup = @holdgame.gamegroups.find( params[:id] )
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
