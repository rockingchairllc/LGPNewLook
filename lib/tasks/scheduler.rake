require 'xml'
require 'net/ftp'
require 'fileutils'
require 'zlib'
require 'xmlsimple'

desc "This task is called by the Heroku scheduler add-on"
task :update_movies => :environment do
    puts "Updating movies..."
    URL = 'on.tmstv.com'
    username='onsample'
    password='125db782'
    filename = "on_usa_samp_mov_programs_20120316.xml.gz"
    localfile = "#{Rails.root}/tmp/#{filename}"
    ftp=Net::FTP.new
    ftp.connect(URL,21)
    ftp.login(username,password)
    ftp.getbinaryfile(filename,localfile)
    ftp.close
    gz=Zlib::GzipReader.open(localfile)
    xml=gz.read
    #puts xml
    parser, parser.string = XML::Parser.new, xml
    doc, programs = parser.parse, []
    doc.find('//programs/program').each do |p|
      #puts XmlSimple.xml_in(p.to_s).to_yaml
      movie_hash=XmlSimple.xml_in(p.to_s)
      if(movie_hash['descriptions'] && movie_hash['genres'])
        TMSId=movie_hash['TMSId']
        if Movie.where(:TMSId=>TMSId).first==nil
          # puts '######################################################'
          #           puts movie_hash['titles'][0]['title'][0]['content']
          #           puts movie_hash['descriptions'][0]['desc'][0]['content']
          #           puts movie_hash['genres'][0]['genre'][0]['content']
          #           puts ['ratings'][0]['rating']
          
          new_movie=Movie.new
          new_movie.TMSId=TMSId
          new_movie.title=movie_hash['titles'][0]['title'][0]['content']
          new_movie.desc_long=movie_hash['descriptions'][0]['desc'][0]['content']
          new_movie.genre=movie_hash['genres'][0]['genre'][0]['content']
          if movie_hash['ratings']!=nil
            if movie_hash['ratings'][0]['rating']!=nil
              movie_hash['ratings'][0]['rating'].each do |rating|
                if rating['area']="United States"
                  new_movie.rating=rating['code']
                end
              end
            end
          end
          if(movie_hash['movieInfo'][0]['releases'][0]['release'].length>1)
            new_movie.release_dt=movie_hash['movieInfo'][0]['releases'][0]['release'][1]['date']
          end
          if(movie_hash['movieInfo'][0]['trailers'])
            new_movie.trailer_url=movie_hash['movieInfo'][0]['trailers'][0]['trailer'][0]['URL'][0]
          end
          puts new_movie.to_yaml
          new_movie.save
         end
      end
      
      #programs = p.to_s
      #programs << p.attributes.inject({}) { |h, a| h[a.name] = a.value; h }
    end
    puts programs.to_s
    #puts hash
    puts "done."
end

task :update_theaters => :environment do
    puts "Updating theaters..."
    URL = 'on.tmstv.com'
    username='onsample'
    password='125db782'
    filename = "on_usa_samp_mov_sources_20120316.xml.gz"
    localfile = "#{Rails.root}/tmp/#{filename}"
    ftp=Net::FTP.new
    ftp.connect(URL,21)
    ftp.login(username,password)
    ftp.getbinaryfile(filename,localfile)
    ftp.close
    gz=Zlib::GzipReader.open(localfile)
    xml=gz.read
    #puts xml
    parser, parser.string = XML::Parser.new, xml
    doc, programs = parser.parse, []
    doc.find('//theatres/theatre').each do |p|
      theater_hash= XmlSimple.xml_in(p.to_s)
      theatreId=theater_hash["theatreId"]
      if Theater.where(:theatreId=>theatreId).first==nil
        puts theater_hash.to_s
        new_theater=Theater.new
        new_theater.theatreId=theatreId
        new_theater.name=theater_hash['name'][0]
        new_theater.address_street=theater_hash['address'][0]['street1'][0]
        new_theater.address_city=theater_hash['address'][0]['city'][0]
        new_theater.address_state=theater_hash['address'][0]['state'][0]
        new_theater.address_zip=theater_hash['address'][0]['postalCode'][0]
        new_theater.address_country=theater_hash['address'][0]['country'][0]
        if theater_hash['telephone']
          new_theater.telephone=theater_hash['telephone'][0]
        end
        new_theater.latitude=theater_hash['latitude'][0]
        new_theater.longitude=theater_hash['longitude'][0]
        new_theater.save
        puts new_theater.to_yaml
      end
      #programs = p.to_s
      #programs << p.attributes.inject({}) { |h, a| h[a.name] = a.value; h }
    end
    puts programs.to_s
    #puts hash
    puts "done."
end

task :update_schedules => :environment do
    puts "Updating schedules..."
    URL = 'on.tmstv.com'
    username='onsample'
    password='125db782'
    filename = "on_usa_samp_mov_schedules_20120316.xml.gz"
    localfile = "#{Rails.root}/tmp/#{filename}"
    ftp=Net::FTP.new
    ftp.connect(URL,21)
    ftp.login(username,password)
    ftp.getbinaryfile(filename,localfile)
    ftp.close
    gz=Zlib::GzipReader.open(localfile)
    xml=gz.read
    #puts xml
    parser, parser.string = XML::Parser.new, xml
    doc, programs = parser.parse, []
    doc.find('//schedules/schedule').each do |p|
      schedulehash= XmlSimple.xml_in(p.to_s)
      #puts schedulehash.to_yaml
      theatreId=schedulehash['theatreId']
      schedulehash['event'].each do |movie|
        TMSId=movie['TMSId']
        date=movie['date']
        #puts movie.to_yaml
        if movie['times']
          movie['times'][0]['time'].each do |time|
            if time['content']
              if time['date']
                tempDate=time['date']
              else
                tempDate=date
              end
              temptime=time['content']
            else
              tempDate=date
              temptime=time
            end
            puts theatreId, TMSId, tempDate +" "+ temptime
          end
        end
        # movie['times'][0]['time'].each do |time|
        #           puts theatreId, TMSId, date, time
        #         end
      end
      #programs = p.to_s
      #programs << p.attributes.inject({}) { |h, a| h[a.name] = a.value; h }
    end
    puts programs.to_s
    #puts hash
    puts "done."
end

task :send_reminders => :environment do
    User.send_reminders
end

