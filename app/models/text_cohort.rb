require 'csv'

class TextCohort < ActiveRecord::Base

  has_many :mass_text_messages
  has_many :text_cohort_entries


  def create_entries_from_file(file)
    CSV.parse(file.read, :headers=>true) do |line|
      puts line.inspect
      TextCohortEntry.create_from_hash( line.to_hash, self.id )
    end
  end

end
