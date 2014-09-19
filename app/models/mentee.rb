#TODO: Create an "Issues" page, that has a list of all the data we are missing (missing data could be sub-category of 'issues', along with unresponsiveness, unmatched people, etc.)
#TODO: Change Mentee Statuses. Keep them but change to history/events model (we can see progression over time)

class Mentee < ActiveRecord::Base
	#associations
	belongs_to :mentor
	belongs_to :highschool
	has_many :surveys
	has_one :app
	has_one :cohort, through: :mentor

	#instance methods
	def name
		return "#{first_name} #{last_name}"
	end

	def TPSyear
		idstring = self.id.to_s
		return "20" + idstring[1..2]
	end

	#TODO: Change this function (Mentee.init) to initialize (which gets called implicitly when you do Mentee.new)
	def init(options = {})
		defaults = {:year => Constant.constants[:cur_year], :status => 'Accepted', :id=>Mentee.new_id}
  		options = defaults.merge(options)
  		puts options
	 	options.keys.each do |attribute|
	    	self[attribute] = options[attribute] 	
	  	end
	  	#puts self.attributes
	end

	# Data that we would like to have; things we would like to fix.
	def issues()
		issues = []
		if self.highschool.blank?
			issues << self.name + " has no highschool assigned."
		end
		if self.mentor.blank?
			issues << self.name + " has no mentor."
		end
		return issues
	end

	#retrieves the mentee associated with the name. If [loose] is set to anything other than 0,
	#it returns the list of mentees whose first OR last name matches the given names
	def self.get_by_name(fname, lname, loose=0)
		if loose !=0
			mentees = Mentee.where(["first_name LIKE ? or last_name LIKE ?","%#{fname}%","%#{lname}%"])
			return mentees
		else
			mentees = Mentee.where(["first_name LIKE ? and last_name LIKE ?","%#{fname}%","%#{lname}%"])
			if mentees.blank?
				return nil
			else
				return mentees[0]
			end
		end
	end

	# TODO: Mentee.add_app will probably break for next year (as will many of the GDrive-interfacing functions). Test and Fix.
	def add_app(mIndex, ws)
		question_start_index = 30
		#check to see if app exists already
		app = self.app
		#if it doesn't exist already, then add it.
		#don't want to overwrite because there may be comments, etc. that get deleted
		if app.blank?
			#add app
			format = "%m/%d/%Y %H:%M:%S"
			begin
				time = DateTime.strptime(ws[mIndex,1], format)
			rescue
				time = nil
			end
			app = App.new(
				:mentee_id => self.id,
				:mentor_id => nil,
				:submitted => time
				)
			app.save
			#figure out last column b/c tool blows
			#last_column = QUESTION_START_INDEX
			last_column = 44
			#add questions to app
			for col in question_start_index..last_column
				q = ws[1,col]
				a = ws[mIndex,col]
				question = Question.new(
					:Q => q,
					:A => a,
					:app_id => app.id,
					:survey_id => nil
					)
				question.save
			end
		end
		return app
	end

	def self.add_app_info(ws, mIndex)
		fname = ws[mIndex,2]
		lname = ws[mIndex,3]
		mentee = Mentee.get_by_name(fname,lname)
		if mentee.blank?
			
			#assign mentee new unique id
			year_prefix = Constant.constants[:year_id_prefix]
			new_id = Mentee.max_id(year_prefix).to_i + 1

			#get hs info from map
			hs_info = {
				:name => ws[mIndex,6],
				:city => ws[mIndex,12],
				:state => ws[mIndex,13],
				:num_students => ws[mIndex,25],
				:num_counselors => ws[mIndex,26]
			}
			#combine 2nd response into "ethnicity", if relevant
			if ws[mIndex,16].blank?
				ethnicity = ws[mIndex,15]
			else
				ethnicity = ws[mIndex,15] + ": " + ws[mIndex,16]
			end
			#flip the first-gen question. We want to know "is dey first gen",
			#and the question asks "did your parents go to college?" so we have to
			#reverse the truth value
			is_first_gen = 'Yes'
			if ws[mIndex,20] == 'Yes'
				is_first_gen = 'No'
			end
			m = Mentee.new(
				:id => new_id,
				:first_name => fname,
				:last_name => lname,
				:year => Constant.constants[:cur_year].to_s,
				:gender => ws[mIndex,5],
				:highschool_id => Highschool.find_or_create_hs(hs_info),
				:email => ws[mIndex,7],
				:phone_1 => ws[mIndex,8],
				:phone_2 => ws[mIndex,10],
				:phone_1_can_text => ws[mIndex,9],
				:street_address => ws[mIndex,11],
	    		:city => ws[mIndex,12],
	    		:state => ws[mIndex,13],
	    		:zip_code => ws[mIndex,14],
	    		:ethnicity => ethnicity,
	    		:free_lunch => ws[mIndex,17],
	    		:income_range => ws[mIndex,18],
	    		:people_in_home => ws[mIndex,19],
	    		:is_first_gen => is_first_gen,
	    		:GPA_u => ws[mIndex,21],
	    		:GPA_w => ws[mIndex,22],
	    		:SAT => ws[mIndex,23],
	    		:ACT => ws[mIndex,24],
	    		:status => "Pending"
				)
			m.save
		else
			m = mentee
		end	
		m.add_app(mIndex, ws)
		Counselor.add_new(m.highschool_id, ws, mIndex, [27,28,29])
	end

	def self.add_new_app_info(ws, mIndex)
		fname = ws[mIndex,2]
		lname = ws[mIndex,3]
		m = Mentee.get_by_name(fname,lname)
		if m.blank?
			Mentee.add_app_info(ws, mIndex)
		end
	end

	def mentor_name()
		return self.mentor.name
	end

	def highschool_name()
		return self.highschool.name
	end

	def status_verbose()
		if self.status == "Accepted"
			return "is in the program"
		elsif self.status == "Pending"
			return "is applying to the program"
		elsif self.status == "Waitlist"
			return "is on the waitlist"
		elsif self.status == "Rejected"
			return "was not accepted to TPS"
		else
			return "[status is unknown]"
		end
	end

	def validate_status()
		valid_statuses = ["Accepted", "Rejected", "Pending","Waitlist","Alum"]
		if not valid_statuses.include? self.status
			errors.add(:status, "is not set to a valid status. Must be one of: [" + valid_statuses.join(", ")+"] ")
		end
	end

	def validate_inputs()
		if first_name.blank?
			errors.add(:first_name, "cannot be blank.")
		end
		if last_name.blank?
			errors.add(:last_name, "cannot be blank.")
		end
		if email.blank?
			errors.add(:email, "cannot be blank.")
		end
		if phone_1.blank?
			errors.add(:phone_1, "cannot be blank.")
		end
		if street_address.blank?
			errors.add(:street_address, "cannot be blank.")
		end
		if city.blank?
			errors.add(:city, "cannot be blank.")
		end
	end

	def self.accepted()
		return self.where(status: "Accepted")
	end

	def self.rejected()
		return self.where(status: "Rejected")
	end

	def self.waitlisted()
		return self.where(status: "Wailist")
	end

	def self.undecided()
		return self.where(status: "Pending")
	end

	def self.current()
		return self.where(year: Constant.constants[:cur_year])
	end

	def self.unassigned()
		return self.where(mentor_id: nil)
	end

	def is_from_cali()
		if (self.state.strip.downcase == "ca") or (self.state.strip.downcase == "california")
			return true
		else
			return false
		end
	end

	def self.no_mentor()
		return self.where('mentor_id is null OR mentor_id = "" ')
	end

	#gets the numerically highest ID of a mentee given the 2-digit year
	#year must be 2-digits, i.e. "13".
	def self.max_id(year)
		year = year.to_s
		if year.length == 4
			year = year [2..3]
		end
		idPrefix = "1" + year
		max_id = Mentee.where("id LIKE ?", "#{idPrefix}%").maximum(:id)
		if max_id.blank?
			return idPrefix + "000"
		end
		return max_id
	end

	def self.new_id()
		max = self.max_id(Constant.constants[:cur_year])
		return (max + 1).to_s
	end

	def self.update_apps()
		user = Constant.constants[:tps_login]
		pass = Constant.constants[:tps_password]
		filename = Constant.constants[:mentee_app_filename]
		session = GoogleDrive.login(user,pass)

		#Get the file and worksheet
		file = session.spreadsheet_by_title(filename)
		ws = file.worksheets[0]
		last_row = 2
		while (not (ws[last_row,1].blank?)) do
			last_row += 1
		end
		for index in 2..last_row
			self.add_app_info(ws, index)
		end
	end

	def get_mentor_preferences()
		app = self.app 
		if app.blank?
			return app
		end
		prefs = app.questions.where("questions.Q LIKE '%in common with your mentor%'")
		return prefs
	end

	def self.get_related_to_search(search)
		sub = "%#{search}%"
		#get mentees whose names are relevant
		mentees = Mentee.joins(:highschool).where('first_name LIKE ? or last_name LIKE ? or 
			mentees.city LIKE ? or email LIKE ? or mentees.id LIKE ? or highschools.name LIKE ?',
			sub, sub, sub, sub, sub, sub)
		mentees += Mentee.joins(:mentor, :highschool).where('
			mentors.first_name LIKE ? or mentors.last_name LIKE ? or 
			mentees.first_name LIKE ? or mentees.last_name LIKE ? or 
			mentees.city LIKE ? or mentees.email LIKE ? or
			mentees.id LIKE ? or highschools.name LIKE ?',
			sub, sub, sub, sub, sub, sub, sub, sub)
		mentees = mentees.uniq

		return mentees
	end

	validate :validate_status, :validate_inputs

end
