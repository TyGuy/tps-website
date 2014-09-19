desc "Import Core Members"


task :import_core_members => :environment do
	require 'csv'
	filename = Constant.constants[:core_member_filename]
	CSV.foreach(filename, :headers => true) do |line|
		#puts line
		atts = line.to_hash
		names = atts["Name"].split(" ")
		fn = names[0]
		if names[1..-1].blank?
			ln = names[1]
		else
			ln = names[1..-1].join(' ')
		end
		if CoreMember.exists?(atts["ID"])
			cm = CoreMember.find(atts["ID"])
			cm.first_name = fn
			cm.year = atts["year"]
			cm.last_name = ln
			cm.team = atts["Team"]
			cm.position = atts["Position"]
			cm.email = atts["Email"]
			cm.phone = atts["Phone Number"]
			#cm.bio = atts["Bio"]
		else
			cm = CoreMember.new(
				:id => atts["ID"],
				:first_name => fn,
				:last_name => ln,
				:year => atts["year"],
				:team => atts["Team"],
				:position => atts["Position"],
				:email => atts["Email"],
				:phone => atts["Phone Number"]#,
				#:bio => atts["Bio"]
				)
		end

		if (not User.exists?(atts["ID"])) and (atts["year"]==Constant.constants[:cur_year].to_s)
			user = User.new(
				:id => atts["ID"],
				:login => names.join("").downcase,
				:password => "phoenix1",
				:permissions => "CoreMember"
				)
			user.save
		end

		cm.save
	end
end