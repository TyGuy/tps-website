class CreateTextCohortEntries < ActiveRecord::Migration
  def change
    create_table :text_cohort_entries do |t|
      t.string :phone
      t.string :fields_json
      t.integer :text_cohort_id
      t.timestamps
    end
  end
end
