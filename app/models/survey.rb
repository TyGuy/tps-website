class Survey < ActiveRecord::Base
	belongs_to :mentor 
	belongs_to :mentee
	has_many :questions
end
