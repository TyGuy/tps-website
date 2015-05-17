class MassTextMessage < ActiveRecord::Base

  #associations:
  belongs_to :text_cohort
  has_many :text_cohort_entries, through: :text_cohort




end
