class HoldgameGamegroupsController < ApplicationController
  layout :resolve_layout
	before_filter :find_holdgame

def index


  @gamegroups = @holdgame.gamegroups

end

def show

  
  @gamegroup = @holdgame.gamegroups.find( params[:id] )
end

def new
 
  @gamegroup = @holdgame.gamegroups.build
  
end

def create
  @gamegroup = @holdgame.gamegroups.build( params[:gamegroup] )
  if @gamegroup.save
    redirect_to holdgame_gamegroups_url( @holdgame )
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
  gon.courtname=@gameholder.courtname+'['+@gameholder.address+']'
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
