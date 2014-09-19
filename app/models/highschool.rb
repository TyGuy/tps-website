#TODO: add a whole new set of pages to the dashboard that help us keep track of highschool information. For example, how often we contact, primary contact, if we do school visits, who went there (me/mo/core), etc. 

class Highschool < ActiveRecord::Base
	has_many :mentees
	has_many :counselors

	#looks for a highschool by name, and creates a new entry if it doesn't already exist.
	def self.find_or_create_hs(hs_info)
		hs = Highschool.find_by_name(hs_info[:name])
		if hs.blank?
			hs = Highschool.new(
				:name => hs_info[:name],
				:city => hs_info[:city],
				:state => hs_info[:state],
				:num_students => hs_info[:num_students],
				:num_counselors => hs_info[:num_counselors]
				)
			hs.save
			return hs.id
		else
			return hs.id
		end
	end

	# Real-time filtering method that updates when you look in the search bar 
	def self.get_related_to_search(search)
		sub = "%#{search}%"
		hss = Highschool.joins(:counselors).where('
			highschools.name LIKE ? or highschools.city LIKE ? or 
			counselors.name LIKE ? or counselors.email LIKE ?',
			sub, sub, sub, sub)
		hss += Highschool.joins(:mentees).where('
			highschools.name LIKE ? or highschools.city LIKE ? or 
			mentees.first_name LIKE ? or mentees.last_name LIKE ?',
			sub, sub, sub, sub)
		hss = hss.uniq.sort_by{ |h| h.id}
		return hss
	end

	def validate_inputs()
		if name.blank?
			errors.add(:name, "cannot be blank.")
		end
		if city.blank?
			errors.add(:city, "cannot be blank.")
		end
		if state.blank?
			errors.add(:state, "cannot be blank.")
		end
	end

	validate :validate_inputs


end
