desc "Import Cohorts"

task :import_cohorts => :environment do
	require 'csv'
	filename = Constant.constants[:cohort_filename]
	CSV.foreach(filename, :headers => true) do |line|
		#line = line.split(",")
		#puts line
		arr_end = line.length() - 1
		year = line[0]
		title = line[1]
		

		#puts mentors
		c = Cohort.new(
			:title => title,
			:year => year
			)
		c.save
		for i in 2..4
			cm_name = line[i]
			unless cm_name.blank?
				cm_name = cm_name.split(" ")
				fn = cm_name[0]
				if cm_name[1..-1].blank?
					ln = cm_name[1]
				else
					ln = cm_name[1..-1].join(' ')
				end
				cm = CoreMember.get_by_name_and_year(fn,ln,year)
				unless cm.blank?
					cm.cohort_id = c.id
					cm.save
				end
			end
		end

		for i in 5..arr_end
			mentor_name = line[i]
			unless mentor_name.blank?
				#puts mentor_name
				mentor_first_name = mentor_name.split(" ")[0]
				mentor_last_name = mentor_name.split(" ")[-1]

				mentor = Mentor.get_by_name_and_year(mentor_first_name, mentor_last_name,year)
				unless mentor.blank?
					mentor.cohort_id = c.id
					mentor.save
				end
			end
		end
	end
end