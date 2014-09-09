class Courtphotos < ActiveRecord::Base
  attr_accessible :photo, :ttcourt_id
  mount_uploader :photo, PlayerPhotoUploader 
end
