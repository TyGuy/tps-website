class Groupgraphs

	def self.mentee_graphs
		gd = []
		gd << { 
			:title => "Mentees By City", :data => Summaries.breakdown('Mentee',:city, {:max_graphs=>8}), :graph_type=>'pie_chart',
			:add_data => ["Most of our mentees are from California (Although I think one is from Maryland... ?)."]
		}
		gd << { :title => "Mentees By Ethnicity",  :data => Summaries.breakdown('Mentee',:ethnicity), :graph_type=>'pie_chart'}
		gd << { 
			:title =>  "Mentees By Income", :data => Summaries.normalize_income_range(Summaries.breakdown('Mentee', :income_range)), 
			:graph_type=> 'column_chart', :add_data => [Summaries.free_red_lunch]
		}
		gd << { :title =>  "Mentees By Gender", :data => Summaries.breakdown('Mentee', :gender), :graph_type=> 'pie_chart' }
		return gd
	end

	def self.mentor_graphs
		gd = []
		gd << { :title => "Mentors By State", :data => Summaries.breakdown('Mentor',:state), :graph_type => 'pie_chart' }		
		gd << { :title => "Mentors By Ethnicity", :data => Summaries.breakdown('Mentor',:ethnicity), :graph_type => 'pie_chart' }
		gd << { :title => "Mentors By Major", :data => Summaries.breakdown('Mentor',:major, {:max_graphs=>8}), :graph_type => 'pie_chart'}
		gd << { :title => "Mentors By Year", :data => Summaries.breakdown('Mentor', :grad_year), :graph_type => 'column_chart' }
		return gd
	end

	def self.hs_graphs
		gd = []
		mentee_hs_data = { :title => "Mentees From Each High School", :data => Summaries.breakdown('Mentee', :highschool_id), :graph_type => 'bar_chart'}
		mentee_hs_data[:graph_options] = {:height => "#{mentee_hs_data[:data].keys.length * 20}px"} 
		gd << mentee_hs_data
		return gd
	end

end