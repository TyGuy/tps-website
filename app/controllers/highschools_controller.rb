class HighschoolsController < ApplicationController

	before_action :require_login

	def download_csv()
		@highschools = get_results("Highschool",[:counselors],flash)
		filename = FileWriter.write_to_csv(@highschools)
		send_file Rails.root.join(filename), :type => 'application/csv', :x_sendfile => true
	end

	def show_all()
		if(params[:sort_by])
			@highschools = Highschool.all.order(params[:sort_by])
		else
			@highschools = Highschool.all
		end
	end

	def show_all_results()
		@highschools = Highschool.get_related_to_search(params[:search])
		flash[:search] = params[:search]
		flash[:sort_by] = params[:sort_by]
		render :partial => "highschools_table"
	end

	def show()
		if(params[:id])
			@highschool = Highschool.find(params[:id])
			@mentees = Mentee.where(highschool_id: @highschool.id)
			@counselors = Counselor.where(highschool_id: @highschool.id)
		end
	end

	def edit()
		@highschool= Highschool.find(params[:id])
	end

	def delete()
		@highschool = Highschool.find(params[:id])
		@highschool.destroy
		flash[:success] = "Highschool permanently deleted from database."
		redirect_to(:action=>"show_all")
	end

	def add_counselor()
		c = Counselor.new(
			:highschool_id => params[:id],
			:name => params[:new_counselor_name],
			:email => params[:new_counselor_email],
			:phone => params[:new_counselor_phone]
			)
		if c.save
			flash[:succees] = "Counselor added!"
			redirect_to( :action => "show", :id => params[:id])
		else
			flash[:error] = "Counselor could not be added."
			redirect_to( :action => "edit", :id => params[:id])
		end
	end

	def edit_basic()
		name = params[:new_name]
		add = params[:new_address]
		city = params[:new_city]
		state = params[:new_state]
		ws = params[:new_website]
		num_c = params[:new_num_counselors]
		num_s = params[:new_num_students]


		hs = Highschool.find(params[:id])
		hs.name = name
		hs.address = add
		hs.city = city
		hs.state = state
		hs.website = ws
		hs.num_counselors = num_c
		hs.num_students = num_s

		if hs.save
			flash[:success] = "High School info successfully changed!"
			redirect_to(:action => "show",:id => hs.id)
		else
			flash[:error] = hs.errors.full_messages
			redirect_to(:action =>"edit", :id=>hs.id)
		end
	end
	

end
