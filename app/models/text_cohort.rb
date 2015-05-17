class TextCohort < ActiveRecord::Base

  has_many :mass_text_messages
  has_many :text_cohort_entries



end
