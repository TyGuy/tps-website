class CreateMentors < ActiveRecord::Migration
  def change
    create_table :mentors do |t|
        t.string :first_name
        t.string :last_name
        t.string :year
        t.string :other_ids #association to other mentors.
        t.string :gender
    	t.string :grad_year
    	t.string :major
    	t.string :hometown
        t.string :state
    	t.string :PO_box
    	t.string :email
    	t.string :phone
    	t.string :highschool_id #association to highschool
    	t.text :ethnicity
        t.string :prior_mentor
    	t.text :demographics
    	t.string :cohort_id #association to cohort
        t.string :core_member_id
        t.string :status
    	t.timestamps
    end
  end
end
