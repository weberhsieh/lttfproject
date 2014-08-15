class Ttcourt < ActiveRecord::Base

 attr_accessible :placename, :lng, :lat, :city, :county , :zipcode, :address, :opentime, :facilities, :playfee,:contactinfo
 attr_accessible :supplyinfo, :infosource,:infoURL 
 after_commit :assign_zipcode
   def gmaps4rails_address
    address
  end

  def gmaps4rails_infowindow
    "<h1>#{placename}</h1>"
  end
  def assign_zipcode
  	self.zipcode=TWZipCode_hash[self.city][self.county]
  	self.save
  end	
   default_scope order('zipcode ASC')
end
