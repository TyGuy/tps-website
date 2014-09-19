class MentorsController < ApplicationController

	before_action :require_login

	def download_csv()
		@mentors = get_results("Mentor",[],flash)
		filename = FileWriter.write_to_csv(@mentors)
		send_file Rails.root.join(filename), :type => 'application/csv', :x_sendfile => true
	end

	def show_all()
		if params[:show_all_years]
			@showing_all_years = params[:show_all_years]
		else
			@showing_all_years = false
			params[:show_all_years] = @showing_all_years
		end
		@mentors = get_results("Mentor",[],params)
	end

	def show_all_results()
		@mentors = get_results("Mentor",[],params)
		flash[:search] = params[:search]
		flash[:sort_by] = params[:sort_by]
		render :partial => "mentor_table"
	end

	def show()
		@mentor = Mentor.find(params[:id])
		@mentees = Mentee.where(mentor_id: @mentor.id)
		if Cohort.exists?(@mentor.cohort_id)
			@cohort = Cohort.find(@mentor.cohort_id)
		end
	end

	def update_apps()
		if Mentor.update_apps
			flash[:success] = "Mentee/Mentor apps updated."
		else 
			flash[:error] = "Ya done fucked up."
		end
		redirect_to(:controller => "apps", :action => "show_current_mentors")
	end

	def view_app()
		@mentor = Mentor.find(params[:id])
		@app = @mentor.app
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
		mentor = Mentor.find(params[:id])
		mentor.status = params[:status]
		if (mentor.save)
			flash[:success] = "Mentor status successfully changed to '"+mentor.status+"'."
			redirect_to(:controller=>"apps", :action=>"show_current_mentors")
		else
			flash[:error] = "Status could not be changed. Please try again."
			redirect_to :back
		end
	end


	def edit()
		@mentor = Mentor.find(params[:id])
	end

	def delete()
		@mentor = Mentor.find(params[:id])
		@mentor.destroy
		flash[:success] = "Mentor permanently deleted from database."
		redirect_to(:action=>"show_all")
	end

	def edit_basic()
		fn = params[:new_first_name]
		ln = params[:new_last_name]
		grad = params[:new_grad_year]
		major = params[:new_major]
		home = params[:new_hometown]
		pobox = params[:new_PO_box]
		email = params[:new_email]
		phone = params[:new_phone]
		eth = params[:new_ethnicity]
		dems = params[:new_demographics]

		mentor = Mentor.find(params[:id])
		mentor.first_name = fn
		mentor.last_name = ln
		mentor.grad_year = grad
		mentor.major = major
		mentor.hometown = home
		mentor.PO_box = pobox
		mentor.email = email
		mentor.phone = phone
		mentor.ethnicity = eth
		mentor.demographics = dems

		if mentor.save
			flash[:success] = "Mentor info successfully changed!"
			redirect_to(:action => "show",:id => mentor.id)
		else
			flash[:error] = mentor.errors.full_messages
			redirect_to(:action =>"edit", :id=>mentor.id)
		end
	end

	def create()

	end

	def add()
		attributes = Helpers.remove_new_prefix(params.to_hash)
		new_id = Mentor.new_id
		m = Mentor.new
		m.init(attributes)
		if m.save
			flash[:success] = "Mentor created successfully. Please add cohorts and mentees."
			redirect_to(:action=>"edit", :id=>m.id)
		else
			flash[:error] = m.errors.full_messages
			redirect_to(:action=>"create")
		end
	end

	def edit_cohort()
		cohort_id = params[:mentor][:cohort_id]
		mentor = Mentor.find(params[:id])
		mentor.cohort_id = cohort_id
		if mentor.save
			flash[:success] = "Mentor info successfully changed!"
			redirect_to(:action => "show",:id => mentor.id)
		else
			flash[:error] = mentor.errors.full_messages
			redirect_to(:action =>"edit", :id=>mentor.id)
		end
	end

	def add_mentee()
		mentee = Mentee.find(params[:mentor][:mentees])
		mentor = Mentor.find(params[:id])
		mentor.mentees << mentee
		if mentor.save
			flash[:success] = "Mentor info successfully changed!"
			redirect_to(:action => "show",:id => mentor.id)
		else
			flash[:error] = mentor.errors.full_messages
			redirect_to(:action =>"edit", :id=>mentor.id)
		end

	end

	def remove_mentee()
		mentor = Mentor.find(params[:id])
		mentee = Mentee.find(params[:person_id])
		mentee.mentor_id = nil
		if mentee.save
			flash[:success] = "Mentee removed (just the connection to this mentor 
				was removed. The mentee was not deleted). "
		else
			flash[:error] = mentee.errors.full_messages
		end
		redirect_to(:action => "edit",:id => mentor.id)
	end




end
