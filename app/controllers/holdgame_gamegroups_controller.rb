class HoldgameGamegroupsController < ApplicationController

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
    redirect_to holdgame_gamegroup_url( @holdgame )
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
end
end
