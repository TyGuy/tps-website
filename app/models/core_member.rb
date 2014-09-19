#TODO: In all model classes: visually separate class and instance methods.
#TODO: Change TPS Year? Really have plenty of space... id thing is kind of jenky. Should just make distinctions (TPSYear, berkeley vs. stanford) explicit.
#TODO: get_by_name could just have default be current year (year=[cur_year]) and we can get rid of CoreMember.get_by_name_and_year (or vice versa) [This is same for mentor and mentee]

class CoreMember < ActiveRecord::Base
	#associations
	belongs_to :cohort
	has_many :comments
	has_one :mentor

	# full name
	def name
		return "#{first_name} #{last_name}"
	end

	# Return all apps assigned to this core member.
	def apps_to_read()
		apps = App.where(assigned_to: self.id)
		return apps
	end

	# Jenky
	def TPSyear
		idstring = self.id.to_s
		return "20" + idstring[1..2]
	end

	def is_reader(app)
		if (app.reader_1.to_s == self.id.to_s or app.reader_2.to_s == self.id.to_s)
			return true
		end
		return false
	end

	# Returns the first core member with that first and last name
	def self.get_by_name(fname, lname)
		cms = CoreMember.where("first_name LIKE ? and last_name LIKE ? ","%#{fname}%","%#{lname}%")
		if cms.blank?
			return nil
		elsif cms.length == 1
			return cms[0]
		else
			return cms
		end
	end

	# Returns the first core member with the first and last name and year
	def self.get_by_name_and_year(fname, lname, year)
		cms = CoreMember.where("first_name LIKE ? and last_name LIKE ? and year = ?","%#{fname}%","%#{lname}%",year)
		if cms.blank?
			return nil
		elsif cms.length == 1
			return cms[0]
		else
			return cms
		end
	end

	# All current Core Members
	def self.current()
		return CoreMember.where('year = ?', Constant.constants[:cur_year])
	end

	# all core members who do not have a cohort (could change name of this to make more clear?)
	def self.available()
		return self.where('cohort_id IS NULL or cohort_id = ? or cohort_id = ?',"",'0')
		#return self.joins(:cohort)
	end

	# Make sure we at least have their name and email upon creation.
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
	end

	validate :validate_inputs

end
