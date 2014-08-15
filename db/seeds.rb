#encoding: UTF-8”
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#file1 = File.read(Rails.root.join('public','information','TWzipcode.json'))
#SeedTWZipCode_hash = JSON.parse(file)
@doc = Nokogiri::XML(File.open(Rails.root.join('public','information','kml.kml')))
@doc.css('Placemark').each do |placemark|
  name = placemark.css('name')
  coordinate = placemark.css('coordinates')
  city = placemark.css('city')
  county = placemark.css('county')
  address = placemark.css('address')
  opentime = placemark.css('opentime')
  facilities = placemark.css('facilities')
  price = placemark.css('price')
  contact = placemark.css('contact')
  sourcer = placemark.css('sourcer')
  otherinfo = placemark.css('otherinfo')
  infoURL = placemark.css('infoURL')
  #if name && coordinates
   
    #coordinates.text.split(' ').each do |coordinate|
      #pos = coordinate.split(',')
      print "coord"+coordinate.text
      @pos=coordinate.text.split(',').collect{ |s| s.to_f }
      print @pos
      print name.text + ","
      #print "#{lat},#{lon}"
      lngval=@pos[0].to_f 
      latval=@pos[1].to_f 

      print lngval
      print latval
      print city.text
      print county.text
      print TWZipCode_hash[city.text][county.text]
      print address.text
      print opentime.text
      print facilities.text 
      print price.text 
      print contact.text
      print sourcer.text
      print otherinfo.text
      print infoURL.text 
   #end 
    ttcourt= Ttcourt.create(placename: name.text, lng:lngval, lat:latval,  city: city.text,  county: county.text,
           zipcode: TWZipCode_hash[city.text][county.text], address: address.text, opentime: opentime.text, 
           facilities: facilities.text , playfee: price.text, contactinfo: contact.text, infosource: sourcer.text, 
           supplyinfo: otherinfo.text, infoURL: infoURL.text)  
               
    puts "\n"
  
end