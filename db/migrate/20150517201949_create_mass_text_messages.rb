class CreateMassTextMessages < ActiveRecord::Migration
  def change
    create_table :mass_text_messages do |t|
      t.timestamp :sent_at
      t.string :content
      t.string :name
      t.integer :text_cohort_id
      t.timestamps
    end
  end
end
