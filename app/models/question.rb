class Question < ActiveRecord::Base
	belongs_to :survey
	belongs_to :app
end
