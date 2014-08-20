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
    @ttcourts = Ttcourt.all
    @ttcourts_hash=Array.new
    @ttcourts.each do |ttcourt|
      @tempcourt=Hash.new
      @tempcourt['id']=ttcourt.id
      @tempcourt['placename']=ttcourt.placename
      @tempcourt['address']=ttcourt.address
      @tempcourt['lat']=ttcourt.lat
      @tempcourt['lng']=ttcourt.lng
      @ttcourts_hash.push(@tempcourt)
    end  
    gon.ttcourts=@ttcourts
    @citiesarray=TWZipCode_hash.keys
    @countiesarray=TWZipCode_hash[@citiesarray[0]].keys
    @areacourts=@ttcourts.find_all{|v| (v["city"]==@citiesarray[0])&&(v["county"]==@countiesarray[0])}
    gon.areacourts=@ttcourts
    @gameholder = current_user.build_gameholder
    @gameholder.user_id=current_user.id
    @gameholder.name=current_user.username
    @gameholder.address= @citiesarray[0]+@countiesarray[0]
    gon.action='new'
    gon.lat=24
    gon.lng=120.5
    gon.countiesarray=@countiesarray
    gon.twzipecode=TWZipCode_hash
    gon.ttcourts=@ttcourts
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
    gon.lat=24
    gon.lng=120.5
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
    
   
    when "edit" ,"new"
      "gameholderedit"  
    else
      "application"
    end
  end
end
