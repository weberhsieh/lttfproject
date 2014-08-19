# encoding: UTF-8”
class PlayerprofilesController < ApplicationController
  before_filter :authenticate_user!  ,:find_user, :except=>[:show,:create,:index, :import, :search]
  helper_method :sort_column, :sort_direction
  # GET /playerprofiles
  # GET /playerprofiles.json
  def index
    #@playerprofiles = Playerprofile.all
     @playerprofiles = Playerprofile.includes(:user).order(sort_column + " " + sort_direction).page(params[:page]).per(50)


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @playerprofiles }
    end
  end

  def search
    reg = /^\d+$/
    if ! reg.match(params[:keyword])
            @playerprofiles = Playerprofile.includes(:user).where( [ "name like ?", "%#{params[:keyword]}%" ]).order(sort_column + " " + sort_direction).page( params[:page] ).per(50)

    else
      @playerprofiles=Array.new
      @tempid=params[:keyword].to_i
      @playerprofiles = Playerprofile.includes(:user).where( :user_id => @tempid).order(sort_column + " " + sort_direction).page( params[:page] ).per(50)

     
    end  
   # @playerprofiles = Playerprofile.where( [ "name like ?", "%#{params[:keyword]}%" ]).page( params[:page] ).per(100)
    render :action => :index
  end 
  def googleplayerlist
    if params[:playerlistfileurl]
      @playerlist=Playerprofile.googleplayerlist(params[:playerlistfileurl])
    end
    
  end

 
  def show
   
    session[:player_id] = params[:id]
    @playerprofile = Playerprofile.find(params[:id])
    
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('date', '日期')
    data_table.new_column('number', '積分走勢')
    if  @playerprofile.gamehistory

      @scorechangearray = @playerprofile.gamehistory.split(/\n/)
    
      data_table.add_rows(@scorechangearray.count)
      (1..@scorechangearray.count).each do |i|
        @record =@scorechangearray.shift
        @gamedate= @record.split("(").first
        @gamescore= @record.split("(").last.split(")").first
    # @rest= @scorechangearray[i].split('(').last
    # @gamescore =@rest.split(')').first
        data_table.set_cell(i-1, 0, @gamedate.to_date)
        data_table.set_cell(i-1, 1, @gamescore.to_i)
    
        end
    else
      data_table.add_rows(1)
      data_table.set_cell(0, 0, @playerprofile.created_at.to_date)
      data_table.set_cell(0, 1, @playerprofile.initscore)

    end 
    opts   = { :width => 700, :height => 400, :title =>  '積分走勢圖', :legend => 'bottom' }
    @chart = GoogleVisualr::Interactive::LineChart.new(data_table, opts)


    @gamekeytofind="_"+@playerprofile.user_id.to_s+"_"+@playerprofile.name+"_"
    @Gamelist=Game.where("players_result like ?","%#{ @gamekeytofind}%").order('created_at DESC')
    @GameTable=Array.new()

      #@GameTable=mda(6,@Gamelist.length)
     
      @Gamelist.each do |gamearray|
        @tempGameTable=Array.new() 
        @tempGameTable.push(gamearray.gamename)
        @currentgamesummery=gamearray.players_result.split(/\n/)
        @destionsummery=@currentgamesummery.select { |v| v =~ /^#{ @gamekeytofind}/ }
        @playergameinfo= @destionsummery[0].split("_")
        (3..7).each do |i|
          @tempGameTable.push(@playergameinfo[i])
        end
        @tempGameTable.push(gamearray.id)
        @tempGameTable.push(@playerprofile.user_id)
        @GameTable.push(@tempGameTable)
    
      end
     
      if @GameTable.present?
        unless @GameTable.kind_of?(Array)
          @GameTable = @GameTable.page(params[:page]).per(20)
        else
          @GameTable = Kaminari.paginate_array(@GameTable).page(params[:page]).per(20)
        end
      end 



    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @playerprofile }
    end
   
  end

  # GET /playerprofiles/new
  # GET /playerprofiles/new.json
  def new
    @playerprofile  = current_user.build_playerprofile
     format.html { redirect_to @playerprofile, notice: 'Playerprofile was successfully new.' }
      respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @playerprofile }
    end
  end

  # GET /playerprofiles/1/edit
  def edit
    @playerprofile = Playerprofile.find(params[:id])
    @user=@playerprofile.user
  end

  # POST /playerprofiles
  # POST /playerprofiles.json
  def create
  #@playerprofile = current_user.playerprofile.build(params[:playerprofile])
  @playerprofile = Playerprofile.where( :user_id => current_user.id).first
  @playerprofile.name=current_user.username
  @playerprofile.save
  
  UserMailer.registration_confirmation(self).deliver

    respond_to do |format|
      if @playerprofile.save
        format.html { redirect_to @playerprofile, notice: 'Playerprofile was successfully created.' }
        format.json { render json: @playerprofile, status: :created, location: @playerprofile }
      else
        format.html { render action: "new" }
        format.json { render json: @playerprofile.errors, status: :unprocessable_entity }
      end
    end
   end

  # PUT /playerprofiles/1
  # PUT /playerprofiles/1.json
  def update
    @playerprofile = Playerprofile.find(params[:id])

    respond_to do |format|
      if @playerprofile.update_attributes(params[:playerprofile])
        format.html { redirect_to @playerprofile, notice: 'Playerprofile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @playerprofile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playerprofiles/1
  # DELETE /playerprofiles/1.json
  def destroy
    @playerprofile = Playerprofile.find(params[:id])
    @playerprofile.destroy

    respond_to do |format|
      format.html { redirect_to playerprofiles_url }
      format.json { head :no_content }
    end
  end
  def import
     Playerprofile.import
     flash[:notice] = "event was successfully updated"
     redirect_to root_url, notice: "Lttfplayers imported."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playerprofile
      @playerprofile = Playerprofile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def playerprofile_params
      params.require(:playerprofile).permit(:user_id, :name, :initscore, :curscore, :totalwongames,  :totallosegames, :lastgamedate, :lastscoreupdatedate, :gamehistory, 
                       :profileurl, :imageurl, :bio, :paddleholdtype, :paddlemodel, :forwardrubber, :backrubber )
    end

    def find_user
    @event = User.find( current_user.id )
  end
  private
  
    def sort_column
      Playerprofile.column_names.include?(params[:sort]) ? params[:sort] : "user_id"
    end
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
