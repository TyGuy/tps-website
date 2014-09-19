class App < ActiveRecord::Base
	belongs_to :mentor 
	belongs_to :mentee 
	has_many :questions
	has_many :comments
#name "App" is used instead of Application because I'm scared of convoluting the terms in Ruby.

	# This returns the score of an app, which is either
	# (1) the average of its 2 scores (if both are given),
	# (2) the given score (if only one given),
	# or (3) 0 (if neither score given).
	def score()
		if self.score_1.blank?
			if self.score_2.blank?
				return 0
			else 
				return score_2
			end
		else
			if self.score_2.blank?
				return score_1
			else 
				return (score_2 + score_1) / 2
			end
		end
	end

	# Make sure scores are between 0 and 20 (when core members input them)
	def validate_score()
		if (not self.score_1.blank?) and (self.score_1 > 20 or self.score_1 < 0)
			errors.add(:score_1, "must be between 0 and 20.")
		end
		if (not self.score_2.blank?) and (self.score_2 > 20 or self.score_2 < 0)
			errors.add(:score_2, "must be between 0 and 20.")
		end
	end

	#returns true if one or more readers have not submitted a score
	def still_unread()
		if (self.score_1.blank? or self.score_2.blank?)
			return true
		end
	end


	# This runs :validate_score (above) upon creation of an App object. 
	validate :validate_score



end
