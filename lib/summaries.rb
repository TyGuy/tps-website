class Summaries


	# options: {
	# 		:title => custom title (default="Class Name Grouped By Attribute Name")
	# 		:max_groups => max number of groups to allow (max = nil, so all groups). (after max, rest get grouped into "all else")
	# 		:blank_name => name to put for group with nil or empty string (default is "Unknown")
	#

	def self.breakdown(class_name, attribute_name, options=nil)
		options ||={}
		options.symbolize_keys
		title = ( !options[:title].blank? )  ? options[:title] : "#{class_name.to_s.camelize} Grouped By #{attribute_name.to_s.camelize}"
		results = eval("#{class_name}.all.group('#{attribute_name}').count")

		#account for blank names
		blank_name = (options[:blank_name].nil?) ? "Unknown" : options[:blank_name]
		u_count = 0 #unknown count
		results.each { |k,v|
			if k.blank?
				u_count += v
				results.delete(k)
			end
		}
		if u_count > 0
			results["Unknown"] = u_count
		end

		#consolidate other groups beyond max
		if !options[:max_groups].nil?
			max_groups = options[:max_groups].to_i
			sorted = results.sort_by{|k, v| v}.reverse
			puts sorted.inspect
			groups = Hash[sorted[0..max_groups-1]]
			o_count = 0
			sorted[max_groups..(sorted.length - 1)].each { |pt| o_count+=pt[1] }
			groups["All Others"] = o_count
			results = groups
		end
		#puts "===============================#{class_name}: #{attribute_name}===================================="
		#results.keys.each {|k| puts k}
		#puts "==================================================================================================="
		return results
	end

	def self.free_red_lunch(mentees=nil)
		mentees ||=Mentee.all
		on_free_lunch = mentees.where(" free_lunch='yes' or free_lunch='Yes' ").count
		total = mentees.count
		percent = (on_free_lunch.to_f / total.to_f * 100).to_i
		return "#{percent}% of our mentees (#{on_free_lunch} out of #{total}) are on free or reduced lunch."
	end



	# this groups same income ranges, and orders them for nice visualization.
	# the first string argument to merge_counts is the one that is kept.
	def self.normalize_income_range(income_hash)
		merge_counts(income_hash,"$0 - $15,000","$0-15,000")
		merge_counts(income_hash,"$15,000 - $30,000","$15,001-$30,000")
		merge_counts(income_hash,"$30,000 - $60,000","$30,001-$60,000")
		merge_counts(income_hash,"$60,000 - $100,000","$60,001-$100,000")
		merge_counts(income_hash,"> $100,000","$100,000 or more")
		return income_hash.sort
	end

	def self.merge_counts(hash,key1,key2)
		hash[key1] += hash[key2]
		hash.delete(key2)
	end

end