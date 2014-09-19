desc "Import Mentee Applications from google drive"

require "rubygems"
require "google_drive"


task :import_mentee_apps => :environment do

	#access constants
	user = Constant.constants[:tps_login]
	pass = Constant.constants[:tps_password]
	filename = Constant.constants[:mentee_app_filename]
	# Log in.
	# You can also use OAuth. See document of
	# GoogleDrive.login_with_oauth for details.
	session = GoogleDrive.login(user,pass)

	#Get the file and worksheet
	file = session.spreadsheet_by_title(filename)
	ws = file.worksheets[0]
	
	#get last row because this google_drive tool has issues
	#supposed to be num_rows but doesn't work
	last_row = 2
	while (not (ws[last_row,1].blank?)) do
		last_row += 1
	end

	for menteeIndex in 2..last_row
		Mentee.add_app_info(ws,menteeIndex)
	end
end


