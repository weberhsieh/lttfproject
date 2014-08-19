class GameholdersController < ApplicationController
	layout :resolve_layout
	before_filter :authenticate_user!  ,:find_user
	def index
    #@playerprofiles = Playerprofile.all
     @gameholders = Gameholder.includes(:user).page(params[:page]).per(50)


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gameholders }
    end
  end
  def new
  
    @gameholder = current_user.build_gameholder
    @gameholder.user_id=current_user.id
    @gameholder.name=current_user.username
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @gameholder }
    end
  end
  def show
  	 @gameholder = Gameholder.find(params[:id])
  	  respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @gameholder}
    end
  end
  def edit
    @gameholder = Gameholder.find(params[:id])
    gon.lat=25
    gon.lng=121
  end

   def create
    

  @gameholder = Gameholder.new(params[:gameholder])
  @gameholder.user_id=current_user.id
  @gameholder.name=current_user.username
  @gameholder.save
    respond_to do |format|
      if @gameholder.save
        format.html { redirect_to @gameholder, notice: 'Game was successfully created.' }
        format.json { render json: @gameholder, status: :created, location: @gameholder }
      else
        format.html { render action: "new" }
        format.json { render json: @gameholder.errors, status: :unprocessable_entity }
      end
    end
  end
def update
     @gameholder = Gameholder.find(params[:id])

    respond_to do |format|
      if @gameholder.update_attributes(params[:gameholder])
        format.html { redirect_to @gameholder, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @gameholder.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @gameholder = Gameholder.find(params[:id])
    @gameholder.destroy

    respond_to do |format|
      format.html { redirect_to gameholders_url }
      format.json { head :no_content }
    end
  end
   def find_user
    @user = User.find( current_user.id )
  end
     private

  def resolve_layout
    case action_name
    
    when "index" 
      "gmapindex"
    when "edit" ,"new"
      "gmapedit"  
    else
      "application"
    end
  end
end
