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

  #@attendee=create_attendee_array(@gamegroups)
  
  #@user_meet_groups=check_user_meetgroupqualify(@gamegroups,current_user.id)
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
     attendantrecord=@curgroup.groupattendants.build
    
     Groupattendant.transaction do
     
     attendantrecord.regtype= @curgroup.regtype
     #attendantrecord.attendee='(,'+current_user.id.to_s+','+current_user.username+','+current_user.email+','+''+')'
     attendantrecord.phone=current_user.phone
     attendantrecord.registor_id=current_user.id
     if attendantrecord.save
       player=attendantrecord.attendants.build
       player.regtype=attendantrecord.regtype
       player.phone=attendantrecord.phone
        player.registor_id=attendantrecord.registor_id
        player.player_id=current_user.id
        player.name=current_user.username
        player.email=current_user.email
        player.curscore=current_user.playerprofile.curscore
        player.save
     end 
   end 

    #@gamegroups = @holdgame.gamegroups
    #@attendee=create_attendee_array(@gamegroups)
    #@targettabindex=@gamegroups.index(@curgroup)+1
   
    redirect_to  holdgame_gamegroups_path(@holdgame, {:targroupid=>@curgroup.id})
end  
def singlegroupregistration(group_id, playerids)
  
  @curgroup=Gamegroup.find(group_id)
  attendantrecord=@curgroup.groupattendants.build 
  @playerlist=Array.new
  @playerlist=User.find(playerids) if playerids

  Groupattendant.transaction do
     
    attendantrecord.regtype= @curgroup.regtype
    attendantrecord.attendee='(,'+current_user.id.to_s+','+current_user.username+','+current_user.email+','+''+')'
    attendantrecord.phone=current_user.phone
    attendantrecord.registor_id=current_user.id
    if attendantrecord.save
      @playerlist.each do |player|
        attendant=attendantrecord.attendants.build
        attendant.regtype=attendantrecord.regtype
        attendant.phone=attendantrecord.phone
        attendant.registor_id=attendantrecord.registor_id
        attendant.player_id=player.id
        attendant.name=player.username
        attendant.email=player.email
        attendant.curscore=player.playerprofile.curscore
        attendant.save
      end 
    end
   
  end 

    #@gamegroups = @holdgame.gamegroups
    #@attendee=create_attendee_array(@gamegroups)
    #@targettabindex=@gamegroups.index(@curgroup)+1
    

end  
def cancel_current_user_registration

  @attendantrecord=Groupattendant.find(params[:user_in_groupattendant])
  @curgroup=@attendantrecord.gamegroup
  @attendantrecord.attendants.delete_all
  @attendantrecord.delete
    
  redirect_to  holdgame_gamegroups_path(@holdgame, {:targroupid=>@curgroup.id})

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

  if params[:singleplayerregistration]
     singlegroupregistration(params[:format], params[:playerid].uniq)
     
                        
    elsif params[:quit]
      @curgroup=Gamegroup.find(params[:format])
    
    else #for "getplayerfromuser" and no name option
      @curgamegroupid=params[:format]
      @curgroup=Gamegroup.find(params[:format])
      reg = /^\d+$/
      @playerlist=Array.new
      @playerlist=User.find(params[:playerid].uniq) if params[:playerid]
      if(params[:keyword])
          
        if ! reg.match(params[:keyword])
          @newplayer = User.where(:username=>params[:keyword]).first
        else
          @newplayer=User.find_by_id(params[:keyword].to_i)  
        end  
        binding.pry
        if !@newplayer 
          flash[:notice] = "無此球友資料，請查明後再輸入!" 
    
        elsif(@curgroup.findplayer(@newplayer.id))
          flash[:notice] = "此球友已經完成報名，請勿重覆報名!"

        elsif params[:playerid] && params[:playerid].include?(@newplayer.id.to_s)
          flash[:notice]="此球友已經輸入("+@newplayer.id.to_s+","+@newplayer.username+")，請勿重覆輸入!"
        elsif !@curgroup.check_meet_group_qualify(@newplayer.playerprofile.curscore) 
          flash[:notice] = "此球友不符合此分組參賽資格，無法報名此分組比賽!"  
           
        else   
           @playerlist.push(@newplayer)
        end  
      end  
    end 
    
    redirect_to  holdgame_gamegroups_path(@holdgame, {:targroupid=>@curgroup.id}) if params[:singleplayerregistration] || params[:quit]      
end

def get_inputplayer(playerlist,keyword)
  reg = /^\d+$/
  if ! reg.match(keyword)
    @newplayer = User.where(:username=>keyword).first
  else
    @newplayer=User.find_by_id(keyword.to_i)  
  end  
  if !@newplayer 
          flash[:notice] = "無此球友資料，請查明後再輸入!" 
    
  elsif(@curgroup.findplayer(@newplayer.id))
          flash[:notice] = "此球友已經完成報名，請勿重覆報名!"

  elsif playerlist && playerlist.include?(@newplayer.id.to_s)
          flash[:notice]="此球友("+@newplayer.id.to_s+","+@newplayer.username+")已經輸入，請勿重覆輸入!"
  elsif !@curgroup.check_meet_group_qualify(@newplayer.playerprofile.curscore) 
          flash[:notice] = "此球友("+@newplayer.id.to_s+","+@newplayer.username+","+@newpayer.playerprofile.curscore.to_s
               +")不符合此分組參賽資格，無法報名此分組比賽!"  
  else
    return @newplayer    
  end
  return nil      
end  

def doubleplayersinput

  if params[:registration]
     singlegroupregistration(params[:format], params[:playerid].uniq)
     
                        
    elsif params[:quit]
      @curgroup=Gamegroup.find(params[:format])
    
    else #for "getplayerfromuser" and no name option
      binding.pry
      @playerlist=Array.new
      @playerlist=User.find(params[:playerid].uniq) if params[:playerid]
      @curgamegroupid=params[:format]
      @curgroup=Gamegroup.find(params[:format])
      if(params[:keyword1] && params[:keyword2])
        @newplayer1=get_inputplayer(params[:playerid],params[:keyword1])
        @newplayer2=get_inputplayer(params[:playerid],params[:keyword2])
        if @newplayer1 && @newplayer2
           @playerlist.push( @newplayer1)
           @playerlist.push( @newplayer2)
        end
      end  
    end 
    
    redirect_to  holdgame_gamegroups_path(@holdgame, {:targroupid=>@curgroup.id}) if params[:registration] || params[:quit]      
   
end
def show

  @gamegroup = @holdgame.gamegroups.find( params[:format] )
  @groupttendee= @gamegroup.groupattendants
  @attendee =@gamegroup.allgroupattendee
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
