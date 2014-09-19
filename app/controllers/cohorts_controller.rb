class CohortsController < ApplicationController

	before_action :require_login

	def show_all()
		if params[:show_all_years]
			@showing_all_years = params[:show_all_years]
		else
			params[:show_all_years] = false
			@showing_all_years = false
		end
		@cohorts = get_results("Cohort",[],params).uniq
	end

	def download_csv()
		@cohorts = get_results("Cohort",[],flash)
		filename = FileWriter.write_to_csv(@cohorts)
		send_file Rails.root.join(filename), :type => 'application/csv', :x_sendfile => true
	end

	def show_all_results()
		@cohorts = get_results("Cohort",[],params)
		flash[:search] = params[:search]
		flash[:sort_by] = params[:sort_by]
		render :partial => "cohorts_table"
	end


	def show()
		@cohort = Cohort.find(params[:id])
		@leaders = @cohort.core_members
		@mentors = @cohort.mentors
		@mentees = @cohort.mentees
	end

	def create()
	end

	def add()
		core_member = CoreMember.find(params[:cohort][:core_members])
		if params[:new_title]
			title = params[:new_title]
		else 
			title = core_member.first_name
		end
		cohort = Cohort.new(
			:title => title,
			:year => Constant.constants[:cur_year]
			)
		cohort.save
		core_member.cohort_id = cohort.id
		core_member.save
		redirect_to(:action => "edit",:id => cohort.id)
	end


	def edit()
		@cohort = Cohort.find(params[:id])
		@leaders = @cohort.core_members
		@mentors = @cohort.mentors
	end

	def add_core_member()
		cohort = Cohort.find(params[:id])
		core_member = CoreMember.find(params[:cohort][:core_members])
		core_member.cohort_id = cohort.id
		if core_member.save
			flash[:success] = "Cohort leader added!"
		else
			flash[:error] = core_member.errors.full_messages
		end
		redirect_to(:action => "edit",:id => cohort.id)
	end

	def add_mentor()
		cohort = Cohort.find(params[:id])
		mentor = Mentor.find(params[:cohort][:mentors])
		mentor.cohort_id = cohort.id
		if mentor.save
			flash[:success] = "Mentor added!"
		else
			flash[:error] = mentor.errors.full_messages
		end
		redirect_to(:action => "edit",:id => cohort.id)
	end

	def remove_core_member()
		cohort = Cohort.find(params[:id])
		core_member = CoreMember.find(params[:person_id])
		core_member.cohort_id = nil
		if core_member.save
			flash[:success] = "Leader removed."
		else
			flash[:error] = core_member.errors.full_messages
		end
		redirect_to(:action => "edit",:id => cohort.id)
	end

	def remove_mentor()
		cohort = Cohort.find(params[:id])
		mentor = Mentor.find(params[:person_id])
		mentor.cohort_id = nil
		if mentor.save
			flash[:success] = "Mentor removed."
		else
			flash[:error] = mentor.errors.full_messages
		end
		redirect_to(:action => "edit",:id => cohort.id)
	end


	def change_title()
		cohort = Cohort.find(params[:id])
		new_title = params[:new_title]
		cohort.title = new_title
		if cohort.save
			flash[:success] = "Cohort name changed!"
		else
			flash[:error] = cohort.errors.full_messages
		end
		redirect_to(:action => "edit",:id => cohort.id)
	end



	def delete()
		@cohort = Cohort.find(params[:id])
		@cohort.core_members.clear
		@cohort.mentors.clear
		@cohort.destroy
		flash[:success] = "Cohort permanently deleted from database."
		redirect_to(:action=>"show_all")
	end

end
