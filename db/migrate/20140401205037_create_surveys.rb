class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
    	# A survey belongs to EITHER a mentee or a mentor. 
    	# We don't enforce having only 1 non-null id (so far), could be a good idea.
    	t.string :mentee_id
    	t.string :mentor_id
      	t.timestamps
    end
  end
end
