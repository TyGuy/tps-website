#TODO: FINISH STATE DEFINITIONS/NORMALIZATIONS

class State
	def self.normalize(state_name)
		state = state_name.to_s.downcase.gsub(/\.,'/,"")
		case state
		when 'al', 'ala', 'alabama'
			return 'AL'
		when 'ak', 'alas', 'alaska'
			return 'AK'
		when 'az', 'ariz', 'arizona'
			return 'AZ'
		when 'ar', 'ark', 'arkansas'
			return 'AR'
		when 'ca', 'cal', 'cali','california'
			return 'CA'
		when 'co', 'col', 'colo', 'colorado'
			return 'CO'
		when 'ct', 'conn', 'connecticut'
			return 'CT'
		when 'de', 'dl', 'del', 'delaware'
			return 'DE'
		when 'dc', 'wash dc', 'washington dc', 'district of columbia'
			return 'DC'
		when 'fl', 'fla', 'flor', 'florida'
			return 'FL'
		when 'ga', 'georgia'
			return 'GA'
		when 'hi', 'ha', 'hawaii'
			return 'HI'
		when 'id', 'ida', 'idaho'
			return 'ID'
		when 'il', 'ill', 'ills', 'illinois'
			return 'IL'
		when 'in', 'ind', 'indy', 'indiana'
			return 'IN'
		when 'ia', 'ioa', 'iowa'
			return 'IA'
		when 'ka', 'ks' 'kan', 'kans', 'kansas'
			return 'KS'
		when 'ky','ken','kent','kentucky'
			return 'KY'
		when 'la', 'louisiana'
			return 'LA'
		when 'me', 'maine'
			return 'ME'
		when 'md', 'maryland'
			return 'MD'
		when 'ma', 'mass', 'massachusetts'
			return 'MA'
		when 'mi', 'mich', 'michigan'
			return 'MI'
		when 'mn', 'minn', 'minnesota'
			return 'MN'
		when 'ms', 'miss', 'mississippi'
			return 'MS'
		when 'mo', 'mizzou', 'missouri'
			return 'MO'
		when 'mt', 'mont', 'montana'
			return 'MT'
		when 'ne', 'nb', 'neb', 'nebr', 'nebraska'
			return 'NE'
		when 'nv', 'nev', 'nevada'
			return 'NV'
		when 'nh', 'new hamp', 'new hampshire', 'hamp', 'hampshire'
			return 'NH'
		when 'nj', 'new jersey', 'jersey'
			return 'NJ'
			#.......................
			#all the other states...
		else
			return "Unknown: #{state}"
		end
	end

	def self.full_names()
		{
		AK: "Alaska", 
        AL: "Alabama", 
        AR: "Arkansas", 
        AS: "American Samoa", 
        AZ: "Arizona", 
        CA: "California", 
        CO: "Colorado", 
        CT: "Connecticut", 
        DC: "District of Columbia", 
        DE: "Delaware", 
        FL: "Florida", 
        GA: "Georgia", 
        GU: "Guam", 
        HI: "Hawaii", 
        IA: "Iowa", 
        ID: "Idaho", 
        IL: "Illinois", 
        IN: "Indiana", 
        KS: "Kansas", 
        KY: "Kentucky", 
        LA: "Louisiana", 
        MA: "Massachusetts", 
        MD: "Maryland", 
        ME: "Maine", 
        MI: "Michigan", 
        MN: "Minnesota", 
        MO: "Missouri", 
        MS: "Mississippi", 
        MT: "Montana", 
        NC: "North Carolina", 
        ND: "North Dakota", 
        NE: "Nebraska", 
        NH: "New Hampshire", 
        NJ: "New Jersey", 
        NM: "New Mexico", 
        NV: "Nevada", 
        NY: "New York", 
        OH: "Ohio", 
        OK: "Oklahoma", 
        OR: "Oregon", 
        PA: "Pennsylvania", 
        PR: "Puerto Rico", 
        RI: "Rhode Island", 
        SC: "South Carolina", 
        SD: "South Dakota", 
        TN: "Tennessee", 
        TX: "Texas", 
        UT: "Utah", 
        VA: "Virginia", 
        VI: "Virgin Islands", 
        VT: "Vermont", 
        WA: "Washington", 
        WI: "Wisconsin", 
        WV: "West Virginia", 
        WY: "Wyoming",
        Unknown: "Unknown"
        }
    end


    def abbrev_to_name(abbrev)
    	abbrev = abbrev.upcase.to_sym
    	return self.full_names[abbrev]
    end

    def name_to_abbrev(name)
    	return normalize(name)
    end

end

