class Helpers

	def self.remove_new_prefix(arg)
		if arg.instance_of?(Hash)
			arg.keys.each { |k| 
				ks = k.to_s
				if ks.include?('new_')
					arg[k.sub('new_', '').to_sym] = arg[k]
				end
				arg.delete(k) 
			}	
		end
		return arg
	end

	#private
	def self.remove_new_prefix_single(string)
		string = string.to_s
		if string.include?('new_')
			sym = string.gsub('new_','').to_sym
		else 
			sym = nil
		end
		return sym
	end

  STRICT_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  EMAIL_REGEX = /[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+/i

end