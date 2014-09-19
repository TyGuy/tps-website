class MenteesController < ApplicationController

	before_action :require_login

	def download_csv()
		@mentees = get_results("Mentee",[:highschool],flash)
		filename = FileWriter.write_to_csv(@mentees)
		send_file Rails.root.join(filename), :type => 'application/csv', :x_sendfile => true
	end

	def show_all()
		if params[:show_all_years]
			@showing_all_years = params[:show_all_years]
		else
			@showing_all_years = false
			params[:show_all_years] = @showing_all_years
		end
		@mentees = get_results("Mentee", [:highschool], params)
	end

	def update_apps()
		if Mentee.update_apps
			flash[:success] = "Mentee/Mentor apps updated."
		else 
			flash[:error] = "Ya done fucked up."
		end
		redirect_to(:controller => "apps", :action => "show_current_mentees")
	end

	def show_all_results()
		@mentees = get_results("Mentee", [:highschool], params)
		flash[:search] = params[:search]
		flash[:sort_by] = params[:sort_by]
		render :partial => "mentee_table"
	end

	def show()
		if(params[:id])
			@mentee = Mentee.find(params[:id])
			@highschool = Highschool.find(@mentee.highschool_id)
			if (@mentee.mentor_id.blank? or @mentee.mentor_id == "[not assigned yet]")
				flash[:error] = "This mentee has no associated mentor in the database."
			elsif not Mentor.exists?(@mentee.mentor_id)
				 flash[:error] = "The mentor with ID " + @mentee.mentor_id + " could not be found in the database."
			else
				@mentor = Mentor.find(@mentee.mentor_id)
			end
			@counselor = Counselor.where(highschool_id: @highschool.id)[0]
		else
			#flash[:error] = something ???
		end
	end


	def view_app()
		@mentee = Mentee.find(params[:id])
		@highschool = @mentee.highschool
		@app = @mentee.app
		if not @app.reader_1.blank?
			@reader_1 = CoreMember.find(@app.reader_1)
		end
		if not @app.reader_2.blank?
			@reader_2 = CoreMember.find(@app.reader_2)
		end
		@questions = @app.questions
		@comments = @app.comments
	end


	def change_status()
		mentee = Mentee.find(params[:id])
		mentee.status = params[:status]
		if (mentee.save)
			flash[:success] = "Mentee status successfully changed to '"+mentee.status+"'."
			redirect_to(:controller=>"apps", :action=>"show_current_mentors")
		else
			flash[:error] = "Status could not be changed. Please try again."
			redirect_to :back
		end
	end

	def edit()
		@mentee= Mentee.find(params[:id])
	end

	def delete()
		@mentee = Mentee.find(params[:id])
		@mentee.destroy
		flash[:success] = "Mentee permanently deleted from database."
		redirect_to(:action=>"show_all")
	end

	def create()

	end

	def add()
		attributes = Helpers.remove_new_prefix(params.to_hash)
		new_id = Mentee.new_id
		m = Mentee.new
		m.init(attributes)
		if m.save
			flash[:success] = "Mentee created successfully. Please add mentee's highschool below. 
			(If the highschool is not in the list, you'll have to add it under the 'highschools' 
				tab and then assign the mentee to it."
			redirect_to(:action=>"edit", :id=>m.id)
		else
			flash[:error] = m.errors.full_messages
			redirect_to(:action=>"create")
		end
	end

	def edit_basic()
		fn = params[:new_first_name]
		ln = params[:new_last_name]
		add = params[:new_street_address]
		city = params[:new_city]
		state = params[:new_state]
		email = params[:new_email]
		phone1 = params[:new_phone_1]
		phone2 = params[:new_phone_2]
		eth = params[:new_ethnicity]
		status = params[:new_status]

		mentee = Mentee.find(params[:id])
		mentee.first_name = fn
		mentee.last_name = ln
		mentee.street_address = add
		mentee.city = city
		mentee.state = state
		mentee.email = email
		mentee.phone_1 = phone1
		mentee.phone_2 = phone2
		mentee.ethnicity = eth
		mentee.status = status

		if mentee.save
			flash[:success] = "Mentee info successfully changed!"
			redirect_to(:action => "show",:id => mentee.id)
		else
			flash[:error] = mentee.errors.full_messages
			redirect_to(:action =>"edit", :id=>mentee.id)
		end
	end

	def edit_highschool()
		highschool_id = params[:mentee][:highschool_id]
		mentee = Mentee.find(params[:id])
		mentee.highschool_id = highschool_id
		if mentee.save
			flash[:success] = "Mentee info successfully changed!"
			redirect_to(:action => "show",:id => mentee.id)
		else
			flash[:error] = mentee.errors.full_messages
			redirect_to(:action =>"edit", :id=>mentee.id)
		end
	end

	def edit_mentor()
		mentor_id = params[:mentee][:mentor_id]
		mentee = Mentee.find(params[:id])
		mentee.mentor_id = mentor_id
		if mentee.save
			flash[:success] = "Mentor info successfully changed!"
			redirect_to(:action => "show",:id => mentee.id)
		else
			flash[:error] = mentee.errors.full_messages
			redirect_to(:action =>"edit", :id=>mentee.id)
		end
	end

	def remove_mentor()
		mentee = Mentee.find(params[:id])
		mentor = Mentor.find(params[:person_id])
		mentee.mentor_id = nil
		if mentee.save
			flash[:success] = "Mentee removed (just the connection to this mentor 
				was removed. The mentee was not deleted). "
		else
			flash[:error] = mentee.errors.full_messages
		end
		redirect_to(:action => "edit",:id => mentee.id)
	end

	#helper method to get mentees based on search and sort criteria
	

end
