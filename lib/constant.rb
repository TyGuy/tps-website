#TODO: MOVE THIS (lib/constant.rb) TO A .YML CONFIG FILE
#TODO: CHANGE cur_year to be updated dynamically (i.e. actually get date and map to TPS year cycle)

class Constant

	def self.constants()
		return {
			#These have readonly permissions so I don't accidentally delete shit.
			:tps_login => "tytheguy08@gmail.com",
			:tps_password => "",

			:mentee_app_filename => "Phoenix Scholars Application 2014 (Responses)",
			:mentor_app_filename => "2014 TPS Mentor Application (Responses)",
			:mentor_filename => "initial/mentors.csv",
			:mentee_filename => "initial/mentees.csv",
			:cohort_filename => "initial/cohorts.csv",
			:core_member_filename => "initial/core_members.csv",
			:berkeley_mentor_filename => "2014 Berkeley Mentor Acceptance (Responses)",

			:year_id_prefix => "14",
			:cur_year => 2014,
			:download_dir => "/downloads"
		}
	end

	def self.app_due_date()
		format = "%m/%d/%Y %H:%M:%S"
		return DateTime.strptime("04/18/2014 23:59:59", format)
	end

	def self.program_years
		return [2014, 2013]
	end

end