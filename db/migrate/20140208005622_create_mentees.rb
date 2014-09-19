class CreateMentees < ActiveRecord::Migration
  def change
    create_table :mentees do |t|
        t.string :first_name
        t.string :last_name
    	t.string :gender
        t.string :year
    	t.string :highschool_id #specific naming convention, association to high school 
    	t.string :email
    	t.string :phone_1
    	t.string :phone_2
    	t.string :phone_1_can_text
    	t.string :street_address
    	t.string :city
    	t.string :state
    	t.string :zip_code
    	t.text :ethnicity
    	t.string :free_lunch
    	t.string :income_range
    	t.string :people_in_home
    	t.string :is_first_gen
    	t.string :GPA_u
    	t.string :GPA_w
    	t.string :SAT
    	t.string :ACT
    	t.string :mentor_id #association to mentor
        t.string :status
      	t.timestamps
    end
  end
end
