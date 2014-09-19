desc "Import New Mentee AND Mentor Applications from google drive"

require "rubygems"
require "google_drive"

#THIS RAKE TASK HAS NOT BEEN TESTED!!!!!


task :update_apps => :environment do

	#constants that may need to change at some point
	user = Constant.constants[:tps_login]
	pass = Constant.constants[:tps_password]
	mentee_filename = Constant.constants[:mentee_app_filename]
	mentor_filename = Constant.constants[:mentor_app_filename]

	# Log in.
	session = GoogleDrive.login(user,pass)

	#Get the file and worksheet
	mentee_file = session.spreadsheet_by_title(mentee_filename)
	ws = mentee_file.worksheets[0]
	last_row = 2
	while (not (ws[last_row,1].blank?)) do
		last_row += 1
	end
	for menteeIndex in 2..last_row
		Mentee.add_new_app_info(ws,menteeIndex)
	end

	#Get the file and worksheet
	mentor_file = session.spreadsheet_by_title(mentor_filename)
	ws = mentor_file.worksheets[0]
	last_row = 2
	while (not (ws[last_row,1].blank?)) do
		last_row += 1
	end
	for mentorIndex in 2..last_row
		Mentor.add_new_app_info(ws,mentorIndex)
	end
end