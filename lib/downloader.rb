#TODO: Rename/move some of the functions of this class to other helper classes. This doesn't only have to do with downloading.

class Downloader

	require 'fileutils'
	require 'rubygems'
	require 'zip'


	def self.create_and_zip_data(class_names, folder_name)
		path = Rails.root.join(folder_name).to_s
		FileUtils.mkdir_p(path) unless File.exists?(path)
		FileUtils.rm_rf(Dir.glob(path+"/*"))
		for name in class_names
			begin
				object_array = eval("#{name}.all")
				FileWriter.write_to_csv(object_array, path)
			rescue
				puts "Skipping " + name + " in database .csv downloads"
			end
		end
		zipfile_name = "tps-"+folder_name.singularize + ".zip"
		zip_directory(path, zipfile_name)
		FileUtils.rm_rf(Dir.glob(path+"/*"))
		return zipfile_name
	end

	def self.zip_directory(full_dir_path, zipfile_name="")

		if zipfile_name == ""
			zipfile_name = full_dir_path.split("/").last + ".zip"
		end

		File.delete(Rails.root.join(zipfile_name)) if File.exist?(Rails.root.join(zipfile_name))

		Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
    		Dir[File.join(full_dir_path, '**', '**')].each do |file|
    			#puts file
    			#file = self.my_strip(file,'/')
    			
    			just_filename = file.sub(full_dir_path+"/", '')
    			entry = zipfile.glob(just_filename).first
    			if entry.blank?
      				zipfile.add(just_filename, file)
      			end
			end
		end
	end

	def self.create_and_zip_all(folder_name)
		table_names = ActiveRecord::Base.connection.tables
		class_names = []
		table_names.each do |name|
			new_name = name.camelize.singularize
			class_names << new_name
		end
		#puts class_names
		zipfile_name = self.create_and_zip_data(class_names, folder_name)
	end

	def self.my_strip(string, chars=nil)
		if chars.blank?
			string = string.strip()
		else
	  		chars = Regexp.escape(chars)
	  		string = string.gsub(/\A[#{chars}]+|[#{chars}]+\Z/, "")
	  	end
	end

	def self.calculate_total_db_size
	    sql = "SELECT table_schema AS 'database',
	                  sum( data_length + index_length ) / ( 1024 *1024 ) AS size
	                  FROM information_schema.TABLES
	                  WHERE ENGINE=('MyISAM' || 'InnoDB' )
	                  AND table_schema = '#{self.get_current_db_name}'"
	    return  self.perform_sql_query(sql)
	  end



	def self.get_current_db_name
	    return Rails.configuration.database_configuration[Rails.env]["database"]
	end

	def self.perform_sql_query(query)
	     result = []
	     mysql_res = ActiveRecord::Base.connection.execute(query)
	     mysql_res.map { |res| result << res }
	     return result
	end

end