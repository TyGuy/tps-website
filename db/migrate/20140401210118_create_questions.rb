class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|

    	# A survey has many questions, and these questions belong to exactly 1 survey 
    	# and 0 or 1 apps.
    	t.text :Q
    	t.text :A 
    	t.string :survey_id
    	t.string :app_id
      t.timestamps
    end
  end
end
