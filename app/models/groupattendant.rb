class Groupattendant < ActiveRecord::Base
  attr_accessible :attendee, :gamegroup_id, :phone, :registor_id, :regtype, :teamname
  belongs_to :gamegroup
end
