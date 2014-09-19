class CreateHighschools < ActiveRecord::Migration
  def change
    create_table :highschools do |t|
    	t.string :name
      t.string :address
    	t.string :city
    	t.string :state
    	t.string :num_students
    	t.string :num_counselors
      t.string :website
    	#t.string :counselor_id
      	t.timestamps
    end
  end
end
