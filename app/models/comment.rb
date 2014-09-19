class Comment < ActiveRecord::Base

	# Comment is for a mentee/mentor application, made by a core member.
	belongs_to :core_member
	belongs_to :app

	# Make sure comment is not blank. 
	def validate_comment()
		if comment.blank?
			errors.add(:comment, "cannot be blank.")
		end
	end

	# called upon creation of comment.
	validate :validate_comment
end
