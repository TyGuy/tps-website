
desc "Import Mentors"

CUR_YEAR = 2013 #year that they applied to TPS


#something is messed up with the logic of mentee existence...
def assignMenteeToMentor(mentee_name,mentor)
	unless mentee_name.blank?
		mentee_name = mentee_name.split(" ")
		mentee_first_name = mentee_name[0]
		mentee_last_name = mentee_name[-1]
		mentee = Mentee.get_by_name(mentee_first_name, mentee_last_name)
		unless mentee.blank?
			mentee.mentor_id = mentor.id
			mentee.save
		end
	end
end


task :import_mentors => :environment do
	require 'csv'
	filename = Constant.constants[:mentor_filename]
	CSV.foreach(filename, :headers => true) do |line|
		atts = line.to_hash
		names = atts["name"].strip.split(" ")
		first_name = names[0]
		last_name = names.from(1).join(" ")
		grad_year = Mentor.get_grad_year(CUR_YEAR,atts["grad_year"])
		cohort_id = 0
		highschool_id = 0
		
		if Mentor.exists?(atts["id"])
			mentor = Mentor.find(atts["id"])
			mentor.first_name = first_name
			mentor.last_name = last_name
			mentor.grad_year = grad_year
			mentor.major = atts["major"]
			mentor.hometown = atts["hometown"]
			mentor.PO_box = atts["PO_box"]
			mentor.email = atts["email"]
			mentor.phone = atts["phone"]
			mentor.ethnicity = atts["ethnicity"]
			mentor.prior_mentor = atts["prior_mentor"]
			mentor.demographics = atts["demographics"]
			mentor.save
		else
			mentor = Mentor.new(
				:id => atts["id"],
				:first_name => first_name,
				:last_name => last_name,
				:year => CUR_YEAR.to_s,
				:grad_year => grad_year,
				:major => atts["major"],
				:hometown => atts["hometown"],
				:PO_box => atts["PO_box"],
				:email => atts["email"],
				:phone => atts["phone"],
				:highschool_id => highschool_id,
				:ethnicity => atts["ethnicity"],
				:prior_mentor => atts["prior_mentor"],
				:demographics => atts["demographics"],
				:cohort_id => 0,
				:status => "Accepted"
				)
			mentor.save
		end
		#puts mentor.name
		assignMenteeToMentor(atts["mentee_1"],mentor)
		assignMenteeToMentor(atts["mentee_2"],mentor)






	end
end
