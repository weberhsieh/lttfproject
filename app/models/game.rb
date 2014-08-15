class Game < ActiveRecord::Base
  attr_accessible :id, :detailgameinfo, :gamedate, :gamename, :originalfileurl, :players_result, :uploader
end
