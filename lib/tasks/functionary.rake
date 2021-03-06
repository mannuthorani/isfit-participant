# encoding: UTF-8

namespace :admin do
  
  task :create_admin_users => :environment do
    func = {
      :username => { :first => "firstname", :last => "lastname" },
    }

    func.each do |username,value|
      password = generate_password.to_s
      email = username.to_s + "@isfit.org"
      first = value[:first]
      last = value[:last]
      user = User.new(:email => email, :first_password => password, :password => password)
      user.save
      UserRole.create(:user_id => user.id, :role_id => 1)
      Functionary.create(:email => email, :user_id => user.id, :first_name => first, :last_name => last)
    end
  end
end

namespace :participant do
  task :make_relations => :environment do
    func = {
      User.find_by_email("xuanhuon@isfit.org") => [33,7,188,185,13,194,21,62,167,168],
      User.find_by_email("juliebb@isfit.org") => [164,29,186,146,8,145,11,65,190],
      User.find_by_email("jkbui@isfit.org") => [200,198,197,3,181,67,155,158,69,98,27,64],
      User.find_by_email("martgjer@isfit.org") => [46,49,179,81,31,91,75,170,45,106,109,113,25,36,53,139,124],
      User.find_by_email("bettinag@isfit.org") => [24,99,166,97,133,74,54],
      User.find_by_email("karinny@isfit.org") => [20,78,38,88,68,202,101,142,180,193,141],
      User.find_by_email("wanda@isfit.org") => [189,71,136,43,105,77,126,80,22,123,14,59],
      User.find_by_email("ayansebo@isfit.org") => [171,79,121,87,96,172,23,103],
      User.find_by_email("marleide@isfit.org") => [114,169,89,140,120,44,2,17,163,199],
      User.find_by_email("annambe@isfit.org") => [125,9,174,173,175,28,176,30,154,132,196,39,48,131,58,159,160,150],
      User.find_by_email("einarsu@isfit.org") => [184,118,37,182,1,26,61,156,34,165,104,119],
      User.find_by_email("egille@isfit.org") => [16,187,177,128,47,10,19,127],
      User.find_by_email("martgies@isfit.org") => [90,40,41,110,82,84,135,85,95,66,144,76,161,116],
    }

    func.each do |user,countries|
      countries.each do |id|
        country = Country.find(id)
        country.participants.each do |p|
          user.functionary.participants << p
        end
        user.save
      end
    end
    
  end

  task :send_travel_info_email => :environment do
    countries = [10,16,17,33,36,37,48,62,69,68,199,132,139,154,172,165,168,167,176,184,187,196]
    puts "Sends email to all participants from given countries."
    sleep 5
    countries.each do |id|
      country = Country.find(id)
      country.participants.where("invited = 1").each do |participant|
        puts "Sending e-mail to: " + participant.email
        ParticipantsMailer.travel_funding(p).deliver!
        puts "E-mail is sent.\n\n"
        sleep 0.5
      end
    end
  end

  task :deadline_failed => :environment do
    #participants = Participant.where("invited = 1 and accepted is null and participants.ignore = 0 and active = 1")
    #participants = Participant.joins("LEFT JOIN (#{DeadlinesUser.where("deadline_id = 5").to_sql}) AS du ON participants.user_id = du.user_id").where("active = 1 AND participants.ignore = 0 AND invited = 1 AND (du.id is null or has_passport is null)")
    #participants = Participant.joins("LEFT JOIN (#{DeadlinesUser.where("deadline_id = 6").to_sql}) AS du ON participants.user_id = du.user_id").where("active = 1 AND participants.ignore = 0 AND invited = 1 AND du.id is null")
    #participants = Participant.joins("LEFT JOIN (#{DeadlinesUser.where("deadline_id = 8").to_sql}) AS du ON participants.user_id = du.user_id").where("active = 1 AND participants.ignore = 0 AND invited = 1 AND du.id is null AND guaranteed is null")
    participants = Participant.joins("LEFT JOIN (#{DeadlinesUser.where("deadline_id = 8").to_sql}) AS du ON participants.user_id = du.user_id").where("active = 1 AND invited = 1 AND du.id is null AND guaranteed is null")
    #participants = Participant.joins("LEFT JOIN (#{DeadlinesUser.where("deadline_id = 9").to_sql}) AS du ON participants.user_id = du.user_id").where("active = 1 AND invited = 1 AND du.id is null AND guaranteed is null")
    puts "#{participants.count} participants will get an email"
    sleep 5
    participants.each do |part|
      puts "Sending e-mail to: " + part.email
      #ParticipantsMailer.failed_deadline(part).deliver!
      #pp = Participant.find_by_id(part.id)
      #pp.active = false
      #pp.save
      puts "E-mail is sent.\n\n"
      sleep 0.5
    end
  end

  task :info_mail => :environment do
    participants = Participant.where("invited = 1 and active = 1 and notified = 0")
    puts "#{participants.count} participants will get an email"
    sleep 5
    participants.each do |part|
      puts "Sending e-mail to: " + part.email
      #ParticipantsMailer.info_mail(p).deliver!
      p.notified = 1
      p.save
      puts "E-mail is sent.\n\n"
      sleep 0.5
    end
  end

  task :set_notified_to_zero => :environment do
    #participants = Participant.joins("LEFT JOIN (#{DeadlinesUser.where("deadline_id = 9").to_sql}) AS du ON participants.user_id = du.user_id").where("active = 1 AND invited = 1 AND du.id is null AND notified = 1")
    participants = Participant.where("invited = 1 and active = 1 and notified = 1")
    participants.each do |part|
      p = Participant.find_by_id(part.id)
      p.notified = 0
      p.save
    end
  end

  task :fix_guaranteed => :environment do
    participants = Participant.joins("LEFT JOIN (#{DeadlinesUser.where("deadline_id = 9").to_sql}) AS du ON participants.user_id = du.user_id").where("active = 1 AND invited = 1 AND du.id is not null AND notified = 1")
    participants.each do |part|
      puts p.email
      #p = Participant.find_by_id(part.id)
      #p.guaranteed = true
      #p.save
    end
  end

  task :waiting_list_answer => :environment do
    participants = Participant.where("invited = 0 and notified = 0")
    puts "#{participants.count} participants will get an email"
    sleep 5
    participants.each do |part|
      p = Participant.find_by_id(part.id)
      puts "Sending e-mail to: " + p.email
      #ParticipantsMailer.waiting_list_answer(p).deliver!
      #p.notified = 1
      p.save
      puts "E-mail is sent.\n\n"
      sleep 0.5
    end
  end

  task :deadline_reminder => :environment do
    #participants = Participant.where("invited = 1 and active = 1 and notified = 1")
    #participants = Participant.joins("LEFT JOIN (#{DeadlinesUser.where("deadline_id = 6").to_sql}) AS du ON participants.user_id = du.user_id").where("active = 1 AND participants.ignore = 0 AND invited = 1 AND du.id is null AND notified = 0")
    participants = Participant.joins("LEFT JOIN (#{DeadlinesUser.where("deadline_id = 9").to_sql}) AS du ON participants.user_id = du.user_id").where("active = 1 AND invited = 1 AND du.id is null AND notified = 0")
    puts "#{participants.count} participants will get an email"
    sleep 5
    participants.each do |part|
      p = Participant.find_by_id(part.id)
      puts "Sending e-mail to: " + p.email
      #ParticipantsMailer.deadline_reminder(p).deliver!
      p.notified = 1
      p.save
      puts "E-mail is sent.\n\n"
      sleep 0.5
    end
  end

  task :make_applicants_into_participants => :environment do
    invites = Application.invited
    invites.each do |invited|
      puts "Processing #{invited.email}"
      # Create User
      user = User.new
      user.email = invited.email.strip
      user.first_password = generate_password
      user.password = user.first_password
      user.roles << Role.find(6)
      user.save

      # Create Participant
      participant = Participant.new
      participant.first_name = invited.first_name.strip
      participant.last_name = invited.last_name.strip
      participant.email = invited.email.strip
      participant.date_of_birth = invited.birthdate
      participant.address1 = invited.address.strip
      participant.zipcode = invited.zipcode
      participant.city = invited.city.strip
      participant.country_id = invited.country_id
      participant.country_citizen_id = invited.country_id
      participant.sex = invited.sex
      participant.field_of_study = invited.field_of_study
      if not invited.final_workshop.nil?
        participant.workshop_id = invited.final_workshop
      else
        puts "FINAL WORKSHOP IS NOT SET. USER ID: #{user.id}"
      end
      participant.user_id = user.id
      participant.notified = 0
      participant.invited = 1
      participant.active = true
      participant.travel_support = invited.travel_amount_given.to_i
      participant.save
      puts "Finished processing #{participant.email}. \n\n\n"

    end
  end

  task :make_applicants_into_waiting_participants => :environment do
    invites = Application.waiting
    invites.each do |invited|
      puts "Processing #{invited.email}"
      # Create User
      user = User.new
      user.email = invited.email.strip
      user.first_password = generate_password
      user.password = user.first_password
      user.roles << Role.find(6)
      user.save

      # Create Participant
      participant = Participant.new
      participant.first_name = invited.first_name.strip
      participant.last_name = invited.last_name.strip
      participant.email = invited.email.strip
      participant.date_of_birth = invited.birthdate
      participant.address1 = invited.address.strip
      participant.zipcode = invited.zipcode
      participant.city = invited.city.strip
      participant.country_id = invited.country_id
      participant.country_citizen_id = invited.country_id
      participant.sex = invited.sex
      participant.field_of_study = invited.field_of_study
      participant.workshop_id = 0
      participant.user_id = user.id
      participant.notified = 0
      participant.invited = 0
      participant.active = true
      participant.travel_support = 0
      participant.save
      puts "Finished processing #{participant.email}. \n\n\n"

    end
  end

  task :email_invited => :environment do
    participants = Participant.where(notified: 0).where(invited: 1)
    puts "Sending email to #{participants.count} people"
    sleep 5
    participants.each do |p|
      puts "Sending e-mail to: " + p.email
      ParticipantsMailer.invitation_letter(p).deliver!
      p.notified = true
      p.save
      puts "E-mail is sent.\n\n"
      sleep 0.5
    end
  end

  task :email_denied => :environment do
    applicants = Application.denied
    puts "Sending email to #{applicants.count} people"
    sleep 5
    applicants.each do |p|
      puts "Sending e-mail to: " + p.email
      ParticipantsMailer.denied(p).deliver!
      p.status = 5 # Set status to 5 for notified uninvited
      p.save
      puts "E-mail is sent.\n\n"
      sleep 0.5
    end
  end

  task :email_waiting => :environment do
    participants = Participant.where(notified: 0).where(invited: 0)
    puts "Sending email to #{participants.count} people"
    sleep 5
    participants.each do |p|
      puts "Sending e-mail to: " + p.email
      ParticipantsMailer.waiting_list(p).deliver!
      p.notified = true
      p.save
      puts "E-mail is sent.\n\n"
      sleep 0.5
    end
  end
end

namespace :sec do
  task :create_sec_users => :environment do
    func = {
      :username => { :first => "firstname", :last => "lastname" },
    }

    func.each do |username,value|
      password = generate_password.to_s
      email = username.to_s + "@isfit.org"
      puts "#{email} #{password}"
      first = value[:first]
      last = value[:last]
      user = User.new(:email => email, :first_password => password, :password => password)
      
      if user.save
        UserMailer.functionary_mail(user).deliver
      end
      
      UserRole.create(:user_id => user.id, :role_id => 4)
      Functionary.create(:email => email, :user_id => user.id, :first_name => first, :last_name => last)
    end
  end


end


namespace :theme do
  task :create_theme_users => :environment do
    func = {
      :username => { :first => "firstname", :last => "lastname" },
    }

    func.each do |username,value|
      password = generate_password.to_s
      email = username.to_s + "@isfit.org"
      puts "#{email} #{password}"
      first = value[:first]
      last = value[:last]
      user = User.new(:email => email, :first_password => password, :password => password)
      
      if user.save
        UserMailer.functionary_mail(user).deliver
      end
      
      UserRole.create(:user_id => user.id, :role_id => 2)
      Functionary.create(:email => email, :user_id => user.id, :first_name => first, :last_name => last)
    end
  end


end

namespace :functionary do

  task :create_functionary_users => :environment do
    func = {
      :username => { :first => "firstname", :last => "lastname" },
    }

    func.each do |username,value|
      password = generate_password.to_s
      email = username.to_s + "@isfit.org"
      puts "#{email} #{password}"
      first = value[:first]
      last = value[:last]
      user = User.new(:email => email, :first_password => password, :password => password)
      
      if user.save
        UserMailer.functionary_mail(user).deliver
      end
      
      UserRole.create(:user_id => user.id, :role_id => 3)
      Functionary.create(:email => email, :user_id => user.id, :first_name => first, :last_name => last)
    end
  end


  task :create => :environment do
    func = {
      :username => { :first => "firstname", :last => "lastname" },
    }
 
    func.each do |username,value|
      password = generate_password.to_s
        email = username.to_s + "@isfit.org"
        first =  value[:first]
        last = value[:last]
        user = User.new(:email => email, :first_password => password, :password => password)
        user.roles << Role.find(2)
        user.save
        Functionary.create(:email => email, :user_id => user.id,:first_name => first, :last_name => last)
    end
  end

	task :make_multiple_relations => :environment do
		Functionary.all.each do |f|
			f.participants.each do |p|
				p.functionaries << f
				p.save
			end
		end
	end

namespace :facilitator do

  task :create => :environment do
    func = {
      :username => { :first => "firstname", :last => "lastname" },
    }
    func.each do |username,value|
      password = generate_password.to_s
        email = username.to_s + "@isfit.org"
        first =  value[:first]
        last = value[:last]
        user = User.new(:email => email, :first_password => password, :password => password)
        user.roles << Role.find(2)
        user.save
        Functionary.create(:email => email, :user_id => user.id,:first_name => first, :last_name => last)
    end

  end

end



  end
namespace :dialogue do

  task :create => :environment do
    func = {
      "5" => ["tanita" ,"hannagri","kennej" ],
      "3" => ["krisdjup" ,"toftoyan" ,"karisyj"],
      "2" => ["marierts" , "sophridd"] ,
      "1" => ["helgasyn","sofielys"] ,
      "4" => ["ullern" , "kristaf" ,"oystf" ]
    }
    role = Role.find(3)
    func.each do |key,value|
      participants = DialogueParticipant.joins(:country).where(:invited => 1).where("countries.region_id = #{key}")
      counter = 0
      funcs = []
      value.each do |username|
        email = username << "@isfit.org"
        funcs << Functionary.find_by_email(email)
      end
      modulo = value.size
      participants.each do |p|
        password = generate_password.to_s
				p password
        user = User.new(:email => p.email, :first_password => password,
                           :password => password)
        user.roles << role
        user.save
        participant = Participant.create(:first_name => p.first_name,
                                         :last_name => p.last_name,
                                         :address1 => p.address1,
                                         :address2 => p.address2,
                                         :zipcode => p.zipcode,
                                         :city => p.city,
																				 :email => p.email,
																				 :field_of_study => p.field_of_study,
                                         :country_id => p.country_id,
                                         :workshop => 18,
                                         :travel_support => p.travel_amount,
                                         :functionary_id => funcs[counter].id,
                                         :user_id => user.id,
                                         :dialogue => 1,
                                         :middle_name => p.middle_name)


        p participant.id

        counter +=1
        counter %= modulo
      end
      #logikk for å knytte opp med functionaries her
    end
  end
end

namespace :admin do
  task :create => :environment do
     func = {
      :username => { :first => "firstname", :last => "lastname" },
    }
 
    func.each do |username,value|
      password = generate_password.to_s
        email = username.to_s + "@isfit.org"
        first =  value[:first]
        last = value[:last]
        user = User.new(:email => email, :first_password => password, :password => password)
        user.roles << Role.find(1)
        user.save
        Functionary.create(:email => email, :user_id => user.id,:first_name => first, :last_name => last)
    end   
  end

	task :transport => :environment do
		password = generate_password.to_s
		puts password
		user = User.new(:email => "magnua@isfit.org", :first_password => password, :password => password)
		user.roles << Role.find(1)
		user.save
		Functionary.create(:email => "magnua@isfit.org", :user_id => user.id, :first_name => "Magnus", :last_name => "Arnhus")
	end


end

namespace :application do
  task :move_from_part => :environment do
    participants = ParticipantsTemp.all
    participants.each do |p|
      application = Application.create!(:first_name => p.first_name,
                                         :last_name => p.last_name,
                                         :address => p.address1,
                                         :zipcode => p.zipcode,
                                         :city => p.city,
                                         :country_id => p.country_id,
                                         :phone => p.phone,
																				 :email => p.email,
                                         :birthdate => p.birthdate,
                                         :sex => p.sex,
                                         :university => p.university,
																				 :field_of_study => p.field_of_study,
                                         :workshop1 => p.workshop1,
                                         :workshop2 => p.workshop2,
                                         :workshop3 => p.workshop3,
                                         :essay1 => p.essay1,
                                         :essay2 => p.essay2,
                                         :travel_apply => p.travel_apply,
                                         :travel_essay => p.travel_essay,
                                         :travel_amount => p.travel_amount,
                                         :travel_nosupport_other => p.travel_nosupport_other,
                                         :travel_nosupport_cancome => p.travel_nosupport_cancome,
                                         :created_at => p.registered_time)
    end
  end
end

namespace :participant do
	task :middle_name_fix => :environment do
		@participants = ParticipantsReal.where(:invited => 1)
		@participants.each do |app|
			@participant = Participant.where(:email => app.email).first
			if @participant
				@participant.middle_name = app.middle_name
				@participant.save
			else
				puts app.id
			end
		end
	end

	task :guaranteed => :environment do
		participants = Participant.where(:visa => 1).where(:accepted => 1).where(:has_passport => 1).where("flightnumber is not null").where("flightnumber <> ''")
		p participants.count
		p "Cancel now if wrong"
		sleep 5
		participants.each do |p|
			p.guaranteed = 1
			p.save
			p "Participant #{p.id} saved"
		end
	end
	
	task :extract => :environment do
		parts = Participant.where(:workshop_id => 15).where(:guaranteed => 1)
		parts.each do |p|
			p p.email
		end
	end

  task :create => :environment do
    func = {
      "5" => ["tanita" ,"hannagri","kennej" ],
      "3" => ["krisdjup" ,"toftoyan" ,"karisyj"],
      "2" => ["marierts" , "sophridd"] ,
      "1" => ["helgasyn","sofielys"] ,
      "4" => ["ullern" , "kristaf" ,"oystf" ]
    }
    role = Role.find(3)
    func.each do |key,value|
      participants = ParticipantsReal.joins(:country).where(:invited => 1).where("countries.region_id = #{key}")
#      participants = []
      counter = 0
      funcs = []
      value.each do |username|
        email = username << "@isfit.org"
        funcs << Functionary.find_by_email(email)
        #p Functionary.find_by_email(email) 
      end
      modulo = value.size
      participants.each do |p|
        password = generate_password.to_s
				p password
        user = User.new(:email => p.email, :first_password => password,
                           :password => password)
        user.roles << role
        user.save
        participant = Participant.create(:first_name => p.first_name,
                                         :last_name => p.last_name,
                                         :address1 => p.address1,
                                         :address2 => p.address2,
                                         :zipcode => p.zipcode,
                                         :city => p.city,
																				 :email => p.email,
																				 :field_of_study => p.field_of_study,
                                         :country_id => p.country_id,
                                         :workshop => p.final_workshop,
                                         :travel_support => p.travel_assigned_amount,
                                         :functionary_id => funcs[counter].id,
                                         :user_id => user.id)


        p participant.id

        counter +=1
        counter %= modulo
      end
      #logikk for å knytte opp med functionaries her
    end
  end

end

def generate_password(size = 8)
  chars = (('a'..'z').to_a + ('0'..'9').to_a) - %w(i o 0 1 l 0)
  (1..size).collect{|a| chars[rand(chars.size)] }.join
end

