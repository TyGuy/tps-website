class CreateCounselors < ActiveRecord::Migration
  def change
    create_table :counselors do |t|
    	t.string :name
    	t.string :highschool_id
    	t.string :email
    	t.string :phone
      	t.timestamps
    end
  end
end
