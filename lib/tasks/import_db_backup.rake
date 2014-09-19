desc "Import all data from database backup"

task :import_db_backup => :environment do
	require 'rubygems'
	require 'zip'
	require 'csv'

	begin
		Zip::File.open('tps-backup.zip') do |zip_file|
	  		# Handle entries one by one
	  		zip_file.each do |entry|
	  			filename = entry.name
	  			entry.extract(filename)
	  			class_name = filename.split("_").first.classify
		    	CSV.foreach(filename, :headers => true) do |line|
					atts = line.to_hash
					eval("#{class_name}.create(#{atts})")
				end
				File.delete(Rails.root.join(filename)) if File.exist?(Rails.root.join(filename))
	  		end
	  		# Find specific entry
	  		# entry = zip_file.glob('').first
	  		# puts entry.get_input_stream.read
		end
	rescue

		backups_dir = "tps-backup"
		
  		Dir.glob(backups_dir+"/*") do |filepath|
  			filename = filepath.split("/").last
  			#puts "======================"
  			#puts filename
  			class_name = filename.split("_").first.classify
	    	CSV.foreach(filepath, :headers => true) do |line|
				atts = line.to_hash
				eval("#{class_name}.create(#{atts})")
			end

		end

	end

end