
desc "Import Mentees"
require 'csv'


task :import_mentees => :environment do
	filename = Constant.constants[:mentee_filename]
	CSV.foreach(filename, :headers => true) do |line|
		#att = line.strip.split(",")
		atts = line.to_hash
		#debugger
		#get city, state, and zip
		#puts atts["city_state_zip"]
		city_state_zip = atts["city_state_zip"].split(",")
		state_zip = city_state_zip[1].strip.split()
		city = city_state_zip[0]
		state = state_zip[0]
		zip = state_zip[1]

		#lookup high school or add if doesn't exist yet.
		hs = Highschool.find_by_name(atts["highschool_name"])
		if hs.blank? then
			hs = Highschool.new(
				:name => atts["highschool_name"], 
				:city => city, 
				:state => state
				#:num_students => atts["hs_num_students"],
				#:num_counselors => atts["hs_num_counselors"]
				)
			hs.save
		end

		#find mentor id for mentee if the mentor is in database already
		if atts["mentor_name"].blank?
			mentor_id = "[not assigned yet]"
		else
			mentor_name = atts["mentor_name"].split()
			mentor = Mentor.where(:first_name=>mentor_name[0]).where(:last_name=>mentor_name[1]).first
			if mentor.blank? then
				mentor_id = "[not assigned yet]"
			else
				mentor_id = mentor.id
			end
		end

		#combine 2nd response into "ethnicity", if relevant
		if atts["ethnicity_2"].blank?
			ethnicity = atts["ethnicity"]
		else
			ethnicity = atts["ethnicity"] + ": " + atts["ethnicity_2"]
		end

		#flip the first-gen question. We want to know "is dey first gen",
		#and the question asks "did your parents go to college?" so we have to
		#reverse the truth value
		is_first_gen = 'Yes'
		if atts["parents_did_college"] == 'Yes'
			is_first_gen = 'No'
		end

		#create counselor enrty based on info we have from mentees
		counselor = Counselor.find_by_email(atts["counselor_email"])
		if counselor.blank?
			counselor = Counselor.new(
				:name => atts["counselor_name"], 
				:email => atts["counselor_email"],
				:phone => atts["counselor_phone"],
				:highschool_id => hs.id
				)
			counselor.save
		end
		unless Mentee.exists?(atts["id"])
			#create mentee
			m = Mentee.new(:id => atts["id"], 
				:first_name => atts["first_name"], 
				:last_name => atts["last_name"], 
				:year => (Constant.constants[:cur_year] - 1).to_s,
				:gender => atts["gender"],
				:highschool_id => hs.id,
				:email => atts["email"],
				:phone_1 => atts["phone_1"],
				:phone_2 => atts["phone_2"],
				:phone_1_can_text => atts["phone_1_can_text"],
				:street_address => atts["street_address"],
	    		:city => city,
	    		:state => state,
	    		:zip_code => zip,
	    		:ethnicity => ethnicity,
	    		:free_lunch => atts["free_lunch"],
	    		:income_range => atts["income_range"],
	    		:people_in_home => atts["people_in_home"],
	    		:is_first_gen => is_first_gen,
	    		:GPA_u => atts["GPA_u"],
	    		:GPA_w => atts["GPA_w"],
	    		:SAT => atts["SAT"],
	    		:ACT => atts["ACT"],
	    		:mentor_id => mentor_id,
	    		:status => "Accepted"
	    		)
			m.save
		end
	end
end












