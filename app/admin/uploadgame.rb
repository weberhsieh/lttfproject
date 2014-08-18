ActiveAdmin.register Uploadgame do
config.sort_order = "created_at_dec"
  index do
  	column :id
    column :gamedate
    column :gamename
    column :players_result
  	column :detailgameinfo
    column :publishedforchecking
    actions
  end


end
