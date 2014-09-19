class CreateCohorts < ActiveRecord::Migration
  def change
    create_table :cohorts do |t|
    	t.string :title
    	t.string :year
      	t.timestamps
    end
  end
end
