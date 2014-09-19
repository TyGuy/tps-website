class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
    	t.string :mentee_id
    	t.string :mentor_id
    	t.string :reader_1
    	t.string :reader_2
    	t.float :score_1
    	t.float :score_2
      t.datetime :submitted
      	t.timestamps
    end
  end
end
