# encoding: UTF-8”
class Gamegroup < ActiveRecord::Base
  attr_accessible :gamefee, :groupname, :grouptype, :holdgame_id, :noofbackupplayers, :noofplayers, :scorehigh
  attr_accessible :scorelimitation, :scorelow, :starttime , :regtype
  belongs_to :holdgame
  has_many :groupattendants
  def self.regtypes
  {'single'=>'個人', 'double'=>'雙人', 'team'=>'團體'}
 end
end
