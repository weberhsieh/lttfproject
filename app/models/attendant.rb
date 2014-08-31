class Attendant < ActiveRecord::Base
  attr_accessible :curscore, :email, :groupattendant_id, :name, :phone, :registor_id, :regtype, :string, :teamname
  attr_accessible :player_id
  belongs_to :groupattendant
end
