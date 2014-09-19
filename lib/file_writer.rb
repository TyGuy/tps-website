class FileWriter
	
	require 'csv'

	def self.write_to_csv(obj_array, directory="")
		class_name = obj_array[0].class.name.split('::').last
		filename = self.generate_filename(class_name, ".csv")

		if directory and directory != ""
			filename = directory + "/" + filename
		end
		begin
			obj_atts = obj_array[0].attributes.keys
			#puts obj_atts
			CSV.open( filename, 'w' ) do |file|
				file << obj_atts
				obj_array.each do |obj|
					#puts obj.attributes.values_at(*obj_atts)
					file << obj.attributes.values_at(*obj_atts)
				end
			end
		rescue
			#do nothing, ignore
		end
		return filename
	end

	def self.write_to_file(obj_array, extension)
		extension = extension.downcase
		if extension == ".csv"
			self.write_to_csv(obj_array)
		else
			raise "sorry, only .csv file extensions are currently supported."
		end

	end

	def self.generate_filename(className, extension)
		timeString = Time.now.in_time_zone('Pacific Time (US & Canada)').strftime("%B_%e_%Y_%I-%M%P")
		return className + "_" + timeString + extension
	end

end