class GameholdersController < ApplicationController
	layout :resolve_layout
	before_filter :authenticate_user!  , :except=>[:index, :show]
  before_filter :find_user
	def index
    #@playerprofiles = Playerprofile.all
    if (current_user) && (current_user.has_role(:admin)||current_user.has_role(:superuser))
       @gameholders = Gameholder.includes(:user).page(params[:page]).per(50)
    else
       @gameholders = Gameholder.alreadyapproved.includes(:user).page(params[:page]).per(50)
    end  

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @gameholders }
    end
  end
  def approve
   @gameholder = Gameholder.find(params[:gameholder_id])
   @gameholder.approved=true
   @gameholder.save
   @gameholders = Gameholder.waitingforapprove.includes(:user).page(params[:page]).per(50) 
   render :action => :approveprocess 
  end  
  def approveprocess
    @gameholders = Gameholder.waitingforapprove.includes(:user).page(params[:page]).per(50) 
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
    @gameholder.approved=false
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
    @countiesarray=TWZipCode_hash[@gameholder.city].keys
    @areacourts=@ttcourts.find_all{|v| (v["city"]==@citiesarray[0])&&(v["county"]==@countiesarray[0])}
    gon.areacourts=@ttcourts   
    gon.lat=@gameholder.lat
    gon.lng=@gameholder.lng
  end

   def create
  binding.pry
  @gameholder = Gameholder.new(params[:gameholder])
  #@gameholder.user_id=current_user.id
  #@gameholder.name=current_user.username
  respond_to do |format|
      if @gameholder.save
         binding.pry
        format.html { redirect_to @gameholder, notice: 'Game was successfully created.' }
        format.json { render json: @gameholder, status: :created, location: @gameholder }
      else
        flash[:notice] = "create failure"
         binding.pry
        format.html { render action: "new", notice: 'create failure' }
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
    
    if(current_user)
       @currentUser_inGameHolder = Gameholder.where( :user_id=> current_user.id  ).first
    end   
  
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
