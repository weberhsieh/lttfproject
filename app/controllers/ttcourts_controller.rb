# encoding: UTF-8”
class TtcourtsController < ApplicationController
  # GET /ttcourts
  # GET /ttcourts.json
  layout :resolve_layout

  def index
    @citiesarray=TWZipCode_hash.keys
    @ttcourts = Ttcourt.all
    @ttcourts_hash=Array.new
    @hash  = Gmaps4rails.build_markers @ttcourts do |ttcourt, marker|
      marker.lat(ttcourt.lat)
      marker.lng(ttcourt.lng)
      marker.infowindow render_to_string(:partial => "/ttcourts/my_info", :formats => [:html],:locals => { :ttcourt => ttcourt})
      marker.picture({
       
                       :width  => "24",
                       :height => "24",
                       
                      })
       
      marker.title(ttcourt.placename)
      marker.json({ :id => ttcourt.id , :name=>ttcourt.placename, :city => ttcourt.city })
      @tempcourt=Hash.new
      @tempcourt['id']=ttcourt.id
      @tempcourt['address']=ttcourt.address
      @tempcourt['opentime']=ttcourt.opentime
      @tempcourt['facilities']=ttcourt.facilities
      @tempcourt['playfee']=ttcourt.playfee
      @ttcourts_hash.push(@tempcourt)
    end
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ttcourts }
    end
  end

  # GET /ttcourts/1
  # GET /ttcourts/1.json
  def show
    @ttcourt = Ttcourt.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @ttcourt }
    end
  end

  # GET /ttcourts/new
  # GET /ttcourts/new.json
  def new
    gon.action='new'
    @ttcourt = Ttcourt.new
    @citiesarray=TWZipCode_hash.keys
    @countiesarray=TWZipCode_hash[@citiesarray[0]].keys
    @ttcourt.address= @citiesarray[0]+@countiesarray[0]
    @ttcourt.opentime = '待補充'
    @ttcourt.facilities = '待補充'
    @ttcourt.opentime = '待補充' 
    @ttcourt.playfee = '待補充'
    @ttcourt.contactinfo = '待補充'
    @ttcourt.supplyinfo = '待補充'
    @ttcourt.infosource = '網路'
    gon.countiesarray=@countiesarray
    gon.twzipecode=TWZipCode_hash
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @ttcourt }
    end
 
  end

  # GET /ttcourts/1/edit
  def edit
    gon.action='edit'
    @ttcourt = Ttcourt.find(params[:id])
    @citiesarray=TWZipCode_hash.keys
    gon.citiesarray=@citiesarray
    @countiesarray=TWZipCode_hash[@ttcourt.city].keys
    gon.countiesarray=@countiesarray
    gon.twzipecode=TWZipCode_hash
    gon.lat=@ttcourt.lat
    gon.lng=@ttcourt.lng
  end

  # POST /ttcourts
  # POST /ttcourts.json
  def create
    @ttcourt = Ttcourt.new(params[:ttcourt])
    respond_to do |format|
      if @ttcourt.save
        format.html { redirect_to @ttcourt, notice: @ttcourt.placename+'資料新增成功!' }
        format.json { render json: @ttcourt, status: :created, location: @ttcourt }
      else
        format.html { render action: "new" }
        format.json { render json: @ttcourt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ttcourts/1
  # PUT /ttcourts/1.json
  def update
    @ttcourt = Ttcourt.find(params[:id])

    respond_to do |format|
      if @ttcourt.update_attributes(params[:ttcourt])
        format.html { redirect_to @ttcourt, notice: @ttcourt.placename+'資料更新成功!' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @ttcourt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ttcourts/1
  # DELETE /ttcourts/1.json
  def destroy
    @ttcourt = Ttcourt.find(params[:id])
    @ttcourt.destroy

    respond_to do |format|
      format.html { redirect_to ttcourts_url }
      format.json { head :no_content }
    end
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
