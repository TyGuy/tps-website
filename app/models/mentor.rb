class Mentor < ActiveRecord::Base
	has_many :mentees
	belongs_to :cohort
	has_many :surveys
	has_one :app
	has_one :core_member

	#instance methods
	def name
		return "#{first_name} #{last_name}"
	end

	#TODO: Change this function (Mentor.init) to initialize (which gets called implicitly when you do Mentor.new)
	def init(options = {})
		defaults = {:year => Constant.constants[:cur_year], :status => 'Accepted', :id=>Mentor.new_id}
  		options = defaults.merge(options)
  		puts options
	 	options.keys.each do |attribute|
	    	self[attribute] = options[attribute] 	
	  	end
	  	#puts self.attributes
	end

	def validate_inputs()
		if first_name.blank?
			errors.add(:first_name, "cannot be blank.")
		end
		if last_name.blank?
			errors.add(:last_name, "cannot be blank.")
		end
	end

	# Here also. Change model to include university.
	def university
		id_string = self.id.to_s

		if id_string[0] == '2'
			return "Stanford"
		elsif id_string[0] == '3'
			return "Berkeley"
		else
			return "Unknown"
		end
	end

	def TPSyear
		idstring = self.id.to_s
		return "20" + idstring[1..2]
	end

	# Improve this. Could have many years, re-think model (look up by name?)
	def year_as_mentor
		if prior_mentor.blank?
			return '1st'
		end
		if prior_mentor.downcase == 'yes' 
			return '2nd'
		else
			return '1st'
		end
	end

	def self.get_by_name_and_year(fname, lname, cur_year)
		mentors = self.get_by_name(fname, lname)
		if mentors.blank?
			return nil
		end
		year_short = cur_year.to_s[2..3] #0-indexed
		if mentors.instance_of?(Mentor)
			mentors = [mentors]
		end
		for mentor in mentors
			if mentor.id.to_s[1..2] == year_short
				return mentor
			end
		end
		return nil
	end

	def self.get_by_name(fname, lname, loose=0)
		if loose !=0
			mentors = Mentor.where(["first_name LIKE ? or last_name LIKE ?","%#{fname}%","%#{lname}%"])
			return mentors
		else
			mentors = Mentor.where(["first_name LIKE ? and last_name LIKE ?","%#{fname}%","%#{lname}%"])
			if mentors.blank?
				return nil
			elsif mentors.length == 1
				return mentors[0]
			else
				return mentors
			end
		end
	end

	def self.max_id(year,prefix="2")
		year = year.to_s
		if year.length == 4
			year = year [2..3]
		end
		idPrefix = prefix + year
		max_id = Mentor.where("id LIKE ?", "#{idPrefix}%").maximum(:id)
		if max_id.blank?
			return idPrefix + "000"
		end
		return max_id
	end

	def self.new_id(prefix="2")
		max = self.max_id(Constant.constants[:cur_year],prefix)
		return (max + 1).to_s
	end

	def self.get_grad_year(curYear, class_level)
		unless class_level.blank?
			if class_level.downcase == "senior" then return curYear
			elsif class_level.downcase == "junior" then return curYear+1
			elsif class_level.downcase == "sophomore" then return curYear+2
			elsif class_level.downcase == "freshman" then return curYear+3
			else return 0
			end
		end
	end

	#instance method of Mentor object
	def add_app(mIndex, ws)
		#check to see if app exists already
		question_start_index = 14
		last_col = 21
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
				:mentor_id => self.id,
				:submitted => time
				)
			app.save
			#add questions to app
			for col in question_start_index..last_col
				q = ws[1,col]
				a = ws[mIndex,col]
				question = Question.new(
					:Q => q,
					:A => a,
					:app_id => app.id,
					)
				question.save
			end
		end
		return app
	end

	#class method of "Mentor" class
	def self.add_app_info(ws, mIndex)
		names = ws[mIndex,2].split(" ")
		fname = names[0]
		if names[1..-1].blank?
			lname = names[1]
		else
			lname = names[1..-1].join(' ')
		end

		cur_year = Constant.constants[:cur_year]
		year_prefix = Constant.constants[:year_id_prefix]
		new_id = Mentor.max_id(year_prefix).to_i + 1

		mentors = Mentor.get_by_name(fname,lname)
		if not mentors.blank?
			if mentors.instance_of?(Mentor)
				mentors = Array(mentors)
			end
			ids = ""
			for men in mentors
				ids += " " + men.id.to_s
			end
			cur_year_mentor = Mentor.get_by_name_and_year(fname,lname,cur_year)
			if cur_year_mentor.blank?
				m = Mentor.new(
					:id => new_id,
					:first_name => fname,
					:last_name => lname,
					:year => Constant.constants[:cur_year].to_s,
					:gender => ws[mIndex,20],
					:email => ws[mIndex,3],
					:phone => ws[mIndex,7],
					:grad_year => Mentor.get_grad_year(cur_year, ws[mIndex,4]),
		    		:hometown => ws[mIndex,5],
		    		:state => ws[mIndex,6],
		    		:major => ws[mIndex,9],
		    		:ethnicity => ws[mIndex, 8],
		    		:PO_box => ws[mIndex,12],
		    		:demographics => ws[mIndex,13],
		    		:prior_mentor => ws[mIndex,10],
		    		:status => "Pending",
		    		:other_ids => ids
					)
				m.save
				mentors.each do |mentor|
					if mentor.other_ids.blank?
						mentor.other_ids = m.id.to_s
					else
						mentor.other_ids = " " + m.id.to_s
					end
				end
			end
		else
			m = Mentor.new(
				:id => new_id,
				:first_name => fname,
				:last_name => lname,
				:year => Constant.constants[:cur_year].to_s,
				:gender => ws[mIndex,20],
				:email => ws[mIndex,3],
				:phone => ws[mIndex,7],
				:grad_year => Mentor.get_grad_year(cur_year, ws[mIndex,4]),
	    		:hometown => ws[mIndex,5],
	    		:state => ws[mIndex,6],
	    		:major => ws[mIndex,9],
	    		:ethnicity => ws[mIndex, 8],
	    		:PO_box => ws[mIndex,12],
	    		:demographics => ws[mIndex,13],
	    		:prior_mentor => ws[mIndex,10],
	    		:status => "Pending"
				)
			m.save
		end

		if not m.blank?
			if m.app.blank?		
				m.add_app(mIndex, ws)
			end
		end
	end

	def self.add_new_app_info(ws, mIndex)
		names = ws[mIndex,2].split(" ")
		fname = names[0]
		lname = names[1]
		m = Mentor.get_by_name_and_year(fname,lname,Constant.constants[:cur_year])
		if m.blank? or m.app.blank?
			Mentor.add_app_info(ws, mIndex)
		end
	end

	def issues()
		issues = []
		if self.mentees.length == 0
			issues << self.name + " has 0 mentees."
		end
		if self.mentees.length > 2
			issues << self.name + " has " + self.mentees.length.to_s + " mentees."
		end
		if self.cohort_id.blank?
			issues << self.name + " is not in a cohort."
		end
		return issues
	end

	def num_mentees_requested()
		if self.app.blank?
			return 2
		end
		question = self.app.questions.where("questions.Q LIKE '%you prefer to have 1 or 2 mentees%'")[0]
		if not question.A.blank?
			num_mentees_want = question.A.to_i
		else
			num_mentees_want = 2
		end
		return num_mentees_want
	end


	def self.update_apps()
		user = Constant.constants[:tps_login]
		pass = Constant.constants[:tps_password]
		filename = Constant.constants[:mentor_app_filename]
		session = GoogleDrive.login(user,pass)

		#Get the file and worksheet
		file = session.spreadsheet_by_title(filename)
		ws = file.worksheets[0]
		last_row = 2
		while (not (ws[last_row,1].blank?)) do
			last_row += 1
		end
		for index in 2..last_row
			self.add_app_info(ws, mIndex)
		end
	end

	def self.get_related_to_search(search)
		sub = "%#{search}%"
		#get mentees whose names are relevant
		mentors = Mentor.where('
			first_name LIKE ? or last_name LIKE ? or 
			hometown LIKE ? or email LIKE ? or
			state LIKE ?',
			sub, sub, sub, sub, sub)
		mentors += Mentor.joins(:mentees).where('(mentees.first_name LIKE ? or mentees.last_name LIKE ?) ',sub, sub)

		return mentors
	end

	def self.stanford()
		return self.where('id LIKE 2%')
	end

	def self.berkeley()
		return self.where('id LIKE 3%')
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

	def self.no_cohort()
		return self.where("cohort_id is null or cohort_id = '' ")
	end

	def self.no_mentee()
		return self.where(:mentees.length == 0)
	end

	def self.too_many_mentees()
		return self.where(:mentees.length > 2)
	end

	def self.get_available()
		avail = []
		mentors = self.where('year= ? and status= ?',Constant.constants[:cur_year], "Accepted")
		#avail = mentors.where(mentees.length: num_mentees_requested.to_i)
		avail = mentors.where(:mentees.length < 2)
		#for m in mentors
		#	num_mentees_want = m.num_mentees_requested.to_i
		#	num_mentees_have = m.mentees.length.to_i
		#	if num_mentees_have < num_mentees_want
		#		avail << m
		#	end
		#end
		return avail
	end

	validate :validate_inputs

end
