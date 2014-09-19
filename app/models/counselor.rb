#TODO: figure out how to define uniqueness on database tables (i.e. primary key) (for all models not just counselor)

class Counselor < ActiveRecord::Base
	belongs_to :highschool

	# adds new counselor from Google Drive spreadsheet (from mentee app)
	def self.add_new(hs_id, ws, mIndex, cols)
		#create counselor enrty based on info we have from mentees
		counselor = Counselor.find_by_email(ws[mIndex, cols[2]])
		if counselor.blank?
			counselor = Counselor.new(
				:name => ws[mIndex, cols[0]], 
				:email => ws[mIndex, cols[2]],
				:phone => ws[mIndex, cols[1]],
				:highschool_id => hs_id
				)
			counselor.save
		end
	end

	def validate_inputs()
		if name.blank?
			errors.add(:name, "cannot be blank.")
		end
		if phone.blank? and email.blank?
			errors.add(:phone, "We need some kind of contact info, so phone and email can't both be blank.")
		end
	end

	validate :validate_inputs

end
