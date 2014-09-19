class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|

    	# comments are for apps.
    	t.text :comment
    	t.string :core_member_id
    	t.string :app_id
    	t.datetime :date_time
      	t.timestamps
    end
  end
end
