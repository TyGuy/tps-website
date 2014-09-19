class DashboardController < ApplicationController

	before_action :require_admin, only: [:admin, :backup_all]
	before_action :require_login, only: [:download_all]

	def index()
		if session[:user_id]
			@user = User.find(session[:user_id])
		else
			@user = nil
		end
	end

	def admin()
	end

	def view_emails()
		@user = User.find(session[:user_id])
	end

	def email_list()
		@user = User.find(session[:user_id])
		if params[:group]=="cohort"
			@cm = @user.get_core_member(Constant.constants[:cur_year])
			@group = @cm.cohort
		elsif params[:group] == "mentees"
			@group = Mentee.current
		elsif params[:group] == "mentors"
			@group = Mentor.current
		end
		if not @group.blank?
			@group = @group.send(params[:subgroup])
		end
	end

	def load_initial_data()
		var = `./bash_scripts/load_data`
		redirect_to :back
	end

	def add_berkeley_mentors
		`rake import_berkeley_mentors`
		flash[:success] = "data loaded."
		redirect_to(:action => "index")
	end


	def rollback_and_reload_from_backup()
		`./bash_scripts/rollback_db`
		`rake db:migrate`
		`rake import_db_backup`
		flash[:success] = "data loaded."
		redirect_to(:action => "index")
	end

	def reload_from_backup()
		`rake db:reset db:migrate`
		`rake import_db_backup`
		flash[:success] = "data loaded."
		redirect_to(:action => "index")
	end

	def update_all_apps()
		if Mentee.update_apps && Mentor.update_apps
			flash[:success] = "Mentee/Mentor apps updated."
		else 
			flash[:error] = "Ya done fucked up."
		end
		redirect_to :back
	end

	def download_all()
		zipfile_name = Downloader.create_and_zip_all("downloads")
		send_file Rails.root.join(zipfile_name), :type => 'application/zip', :x_sendfile => true
		return
	end

	def backup_all()
		zipfile_name = Downloader.create_and_zip_all("backups")
		flash[:success] = "All DB files were backed up!"
		redirect_to :back
	end

	def get_db_size()
		puts Downloader.calculate_total_db_size
		redirect_to(:action=>"index")
	end

	def match()
		@mentees = Mentee.where('mentor_id is NULL and year = ? and status = ?', Constant.constants[:cur_year], "Accepted")
		#@mentees = Mentee.join(:mentor).where('year= ? ',nil, Constant.constants[:cur_year])

		#@mentors = Mentor.where('year= ?',Constant.constants[:cur_year])
		#@mentors = @mentors.where(:mentees.length < 2)
		cm_cohort_id = CoreMember.find(session[:user_id]).cohort_id
		@mentors = Mentor.where('cohort_id = ? and year = ?',cm_cohort_id,Constant.constants[:cur_year])
		if params[:mentee_id]
			@cur_mentee = Mentee.find(params[:mentee_id])
		else
			@cur_mentee=nil
		end
		if params[:mentor_id]
			@cur_mentor = Mentor.find(params[:mentor_id])
		else
			@cur_mentor=nil
		end	
	end

	def actually_match()
		mentee = Mentee.find(params[:mentee_id])
		mentor = Mentor.find(params[:mentor_id])
		mentee.mentor_id = mentor.id
		mentee.save
		redirect_to(:action=>"match")
	end

	def show_issues()
		@empty_cohorts = Cohort.current.empty
		@mentors_no_cohort = Mentor.current.no_cohort
		@mentors_no_mentee = Mentor.current.no_mentee
		@mentors_too_many_mentees = Mentor.current.too_many_mentees
		@mentees_no_mentor = Mentee.current.no_mentor
		@total_issues = @empty_cohorts.length + @mentors_no_cohort.length + @mentors_no_mentee.length + @mentors_too_many_mentees.length + @mentees_no_mentor.length
	end

	def summaries()
		group = params[:group] || 'mentees'
		puts "============================================================"
		puts group
		
		if group.downcase == 'mentees'
			@graph_data = Groupgraphs.mentee_graphs
		elsif group.downcase == 'mentors'
			@graph_data = Groupgraphs.mentor_graphs
		elsif group.downcase.in?(['highschool', 'hs', 'highschools'])
			@graph_data = Groupgraphs.hs_graphs
		else
			@graph_data = []
		end
		puts "#{@graph_data.inspect}"
	end

	def feedback()
	end

	def mail_feedback()
		message = params[:new_message]
		user = User.find(session[:user_id])
		FeedbackSender.send_feedback(user,message).deliver
		flash[:success] = "Thanks for the feedback! Your email has been sent."
		redirect_to(:action=>"feedback")
	end
	
end

