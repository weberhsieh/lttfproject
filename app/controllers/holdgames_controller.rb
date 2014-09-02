# encoding: UTF-8”
class HoldgamesController < InheritedResources::Base
 
  before_filter :authenticate_user! , :except=>[:index,:show]
  before_filter :find_gameholder
  
  def index
    @holdgames=Holdgame.includes(:gameholder).page(params[:page]).per(50)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @holdgames }
    end
  end
  def show
  	  @holdgame= Holdgame.find(params[:id])
  	  respond_to do |format|
        format.html # show.html.erb
        format.json { render json:@holdgame}
      end
  end 
  def new
  
  	
  	@holdgame = Holdgame.new(:gameholder_id => @cur_gameholder.id)
  	 respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @holdgame }
    end
  end	
  def edit
  	 @holdgame = Holdgame.find(params[:id])
  	 respond_to do |format|
       format.html # show.html.erb
       format.json { render json: @holdgame}
     end
  end	
  def create
  	@holdgame = Holdgame.new(params[:holdgame])
  	@holdgame.gameholder_id=@cur_gameholder.id
  	respond_to do |format|
      if @holdgame.save
 
        format.html { redirect_to holdgame_gamegroups_path(@holdgame), notice: '比賽資料建檔完成!' }
        format.json { render json: @holdgame, status: :created, location: @holdgame }
      else
        flash[:notice] = "比賽資料建檔資料失敗!"

        format.html { render action: "new", notice: '比賽資料建檔資料失敗，請跟管理員連絡辦理!' }
        format.json { render json: @holdgame.errors, status: :unprocessable_entity }
      end
    end
  end	

  def update
    @holdgame = Holdgame.find(params[:id])
    respond_to do |format|
      if @holdgame.update_attributes(params[:holdgame])
        format.html { redirect_to @holdgame, notice: '資料修改成功.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" ,notice: '資料修改失敗，請跟管理員連絡辦理!'}
        format.json { render json: @holdgame.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @holdgame = Holdgame.find(params[:id])
    @holdgame.destroy

    respond_to do |format|
      format.html { redirect_to holdgames_url }
      format.json { head :no_content }
    end
  end
  private
  def find_gameholder
  	@cur_gameholder= Gameholder.where( :user_id=> current_user.id  ).first
  end	
end
