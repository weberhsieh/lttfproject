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
    @targettabindex=params[:targettab]
  end  
  @attendee=create_attendee_array(@gamegroups)
 
  
end
def create_attendee_array(gamegroups)
 @attendee_array=Array.new
 gamegroups.each do |gamegroup|
 @attendee_array.push(expand_attendee(gamegroup.regtype,gamegroup.groupattendants))
 end
 return @attendee_array
end  
def expand_attendee(regtype,groupattendee)
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
        user=User.find(attendant['user_id'])
        attendant['curscore']=user.playerprofile.curscore 
        attendant['email']=user.email
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
     binding.pry
     @curgroup=Gamegroup.find(params[:gamegroup_id])
     attendant=@curgroup.groupattendants.build
     binding.pry
     Groupattendant.transaction do
     
     attendant.regtype= @curgroup.regtype
     attendant.attendee='(,'+current_user.id.to_s+','+current_user.username+','+current_user.email+','+'隊長'+')'
     attendant.save 
   end 

    @gamegroups = @holdgame.gamegroups
    @attendee=create_attendee_array(@gamegroups)
    @targettabindex=@gamegroups.index(@curgroup)+1
    
    redirect_to  holdgame_gamegroups_path(@holdgame), :targettab=> @targettabindex
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
