class CreateCoreMembers < ActiveRecord::Migration
  def change
    create_table :core_members do |t|
    	t.string :first_name
    	t.string :last_name
      t.string :year
    	t.string :email
    	t.string :phone
    	t.string :team
    	t.string :position
    	t.text :bio
    	t.string :cohort_id
      t.string :mentor_id
      t.timestamps
    end
  end
end
