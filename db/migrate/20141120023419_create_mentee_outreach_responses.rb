class CreateMenteeOutreachResponses < ActiveRecord::Migration
  def change
    create_table :mentee_outreach_responses do |t|
      t.string :mentee_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :response_type #website or text or email
      t.string :highschool_id
      t.string :t_msg_id
      t.string :t_msg_from_city
      t.string :t_msg_from_state
      t.string :t_msg_from_zip
      t.string :t_msg_body
      t.datetime :sent_at
      t.timestamps
    end
  end
end
