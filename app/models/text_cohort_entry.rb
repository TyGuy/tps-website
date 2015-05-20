class TextCohortEntry < ActiveRecord::Base

  belongs_to :text_cohort

  def self.create_from_hash(hash, cohort_id)
    e = TextCohortEntry.new(:text_cohort_id => cohort_id, :phone=>hash['phone'])
    hash.delete('phone')
    e.fields_json = hash.to_json
    e.save
    e
  end

end
