desc "Import Berkeley Mentors"

require "rubygems"
require "google_drive"

def addBerkeleyMentors(ws,mentorIndex)

	names = ws[mentorIndex,5].split(" ")
	fname = names[0]
	names.shift
	lname = names.join(" ")


	cur_year = Constant.constants[:cur_year]
	year_prefix = Constant.constants[:year_id_prefix]
	cur_year_mentor = Mentor.get_by_name_and_year(fname,lname,cur_year)

	
	if cur_year_mentor.blank?
		new_id = Mentor.max_id(year_prefix,"3").to_i + 1
		m = Mentor.new(
			:id => new_id,
			:first_name => fname,
			:last_name => lname,
			:email => ws[mentorIndex,6],
			:year => "2014",
			:status => "Accepted"
			)
		m.save
	end
end

task :import_berkeley_mentors => :environment do

	user = Constant.constants[:tps_login]
	pass = Constant.constants[:tps_password]
	filename = Constant.constants[:berkeley_mentor_filename]

	#log in.
	session = GoogleDrive.login(user,pass)

	#Get the file and worksheet
	file = session.spreadsheet_by_title(filename)
	ws = file.worksheets[0]

	last_row = 2
	while (not (ws[last_row,1].blank?)) do
		last_row += 1
	end

	for mentorIndex in 2..last_row
		addBerkeleyMentors(ws,mentorIndex)
	end
end