class Cohort < ActiveRecord::Base
	has_many :mentors
	has_many :core_members
	has_many :mentees, through: :mentors

	# This is the current (fairly jenky) search method, which is used to update the 
	# mentee/mentor/cohort/whatever list in real-time when people type in the search
	# bar. Could be expanded.
	def self.get_related_to_search(search)
		sub = "%#{search}%"
		cohorts = Cohort.joins(:mentors, :core_members).where('cohorts.title LIKE ? or
			mentors.first_name LIKE ? or mentors.last_name LIKE ? or
			core_members.first_name LIKE ? or core_members.last_name LIKE ? or 
			title LIKE ?',
			sub, sub, sub, sub, sub, sub).uniq

		return cohorts
	end


	# Returns all members as an array
	# TODO: Check where this is called, see if necessary (or if could be
	# eliminated	
	def all_members()
		members = []
		if not self.core_members.blank?
			members += self.core_members
		end
		if not self.mentors.blank?
			members += self.mentors
		end
		if not self.mentees.blank?
			members += self.mentees
		end
		return members
	end

	# Return all current cohorts.
	def self.current()
		return self.where(year: Constant.constants[:cur_year])
	end

	# return all cohorts where either (1) they have no leaders or (2)
	# they have no mentors.
	def self.empty()
		to_return = []
		self.all do |cohort|
			cms = cohort.core_members
			mentors = cohort.mentors
			if cms.blank? or mentors.blank?
				to_return << cohort
			end
		end
		return to_return
	end

end
