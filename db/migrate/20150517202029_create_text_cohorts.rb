class CreateTextCohorts < ActiveRecord::Migration
  def change
    create_table :text_cohorts do |t|
      t.string :name
      t.timestamps
    end
  end
end
