# encoding: UTF-8”
class GamesmapsController < ApplicationController
  # GET /ttcourts
  # GET /ttcourts.json
  layout :resolve_layout

  def index
    @citiesarray=TWZipCode_hash.keys

    @holdgames=Holdgame.all
    @holdgames_hash=Array.new
    @hash  = Gmaps4rails.build_markers @holdgames do |holdgame, marker|
      marker.lat(holdgame.lat)
      marker.lng(holdgame.lng)
      marker.infowindow render_to_string(:partial => "/gamesmaps/my_info", :formats => [:html],:locals => { :holdgame => holdgame})
      marker.picture({
       
                       :width  => "24",
                       :height => "24",
                       
                      })
       
      marker.title(holdgame.courtname)
      marker.json({ :id => holdgame.id , :name=>holdgame.startdate.to_s+holdgame.gamename+'('+holdgame.courtname+')', :city => holdgame.city })
      @tempgame=Hash.new
      @tempgame['id']=holdgame.id
      @tempgame['gamename']=holdgame.gamename
      @tempgame['courtname']=holdgame.courtname
      @tempgame['address']=holdgame.address
      @tempgame['startdate']=holdgame.startdate
      @tempgame['gamenote']=holdgame.gamenote
      @holdgames_hash.push( @tempgame)
    end
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @holdgames }
    end
  end

  # GET /ttcourts/1
  # GET /ttcourts/1.json
  def show
    @holdgame = Holdgame.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @holdgame }
    end
  end

  # GET /ttcourts/new
  # GET /ttcourts/new.json
  def new
    gon.action='new'
    @holdgame = Holdgame.new
    @citiesarray=TWZipCode_hash.keys
    @countiesarray=TWZipCode_hash[@citiesarray[0]].keys
    @holdgame.address= @citiesarray[0]+@countiesarray[0]
    
    gon.countiesarray=@countiesarray
    gon.twzipecode=TWZipCode_hash
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @holdgame }
    end
 
  end

  # GET /ttcourts/1/edit
  def edit
    gon.action='edit'
    @holdgame = Holdgame.find(params[:id])
    @citiesarray=TWZipCode_hash.keys
    gon.citiesarray=@citiesarray
    @countiesarray=TWZipCode_hash[@ttcourt.city].keys
    gon.countiesarray=@countiesarray
    gon.twzipecode=TWZipCode_hash
    gon.lat=@holdgame.lat
    gon.lng=@holdgame.lng
  end

  # POST /ttcourts
  # POST /ttcourts.json
  def create
    @holdgame = Holdgame.new(params[:holdgame])

    respond_to do |format|
      if @holdgame.save
        format.html { redirect_to @holdgame, notice: @holdgame.gamename+'資料新增成功!' }
        format.json { render json: @holdgame, status: :created, location: @holdgame }
      else
        format.html { render action: "new" }
        format.json { render json:@holdgame.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ttcourts/1
  # PUT /ttcourts/1.json
  def update
    @holdgame = Holdgame.find(params[:id])

    respond_to do |format|
      if @ttcourt.update_attributes(params[:holdgame])
        format.html { redirect_to @holdgame, notice: @holdgame.gamename+'資料更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @holdgame.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ttcourts/1
  # DELETE /ttcourts/1.json
  def destroy
    @holdgame = Holdgame.find(params[:id])
    @holdgame.destroy

    respond_to do |format|
      format.html { redirect_to holdgames_url }
      format.json { head :no_content }
    end
  end
    private

  def resolve_layout
    case action_name
    
    when "index" 
      "gamesmaplayout"
    when "edit" ,"new"
      "gmapedit"  
    else
      "application"
    end
  end
end

