class AppsController < ApplicationController

	before_action :require_login

	def show_current_mentees()
		mentees = Mentee.where(year: Constant.constants[:cur_year]).includes(:app)
		@unread_mentees = mentees.where(status: "Pending")
		@accepted_mentees = mentees.where(status: "Accepted")
		@waitlist_mentees = mentees.where(status: "Waitlist")
		@rejected_mentees = mentees.where(status: "Rejected")

		@readers = CoreMember.current
		#for app in apps do
		#	mentee = app.mentee
		#	if (not mentee.blank?) and mentee.TPSyear == "2014"
		#		if (params[:filter]=="true" and CoreMember.find(session[:user_id]).is_reader(app)) or 
		#			(params[:filter].blank? or params[:filter]=="false")
		#			mentees << mentee
		#		end
		#	end
	#	end
	#	@unread_mentees = []
	#	@accepted_mentees = []
	#	@waitlist_mentees = []
	#	@rejected_mentees = []
	#	for mentee in mentees
	#		if mentee.status == "Accepted"
	#			@accepted_mentees << mentee
	#		elsif mentee.status == "Pending"
	#			@unread_mentees << mentee
	#		elsif mentee.status == "Waitlist"
	#			@waitlist_mentees << mentee
	#		elsif mentee.status == "Rejected"
	#			@rejected_mentees << mentee
	#		end
	#	end
	end


	def show_current_mentors()
		mentors = Mentor.includes(:app).where("year = ? AND apps.id IS NOT NULL", Constant.constants[:cur_year])
		@unread_mentors = mentors.where(status: "Pending")
		@accepted_mentors = mentors.where(status: "Accepted")
		@waitlist_mentors = mentors.where(status: "Waitlist")
		@rejected_mentors = mentors.where(status: "Rejected")

		@readers = CoreMember.current
		#apps = App.find(:all)
		#mentors = []
		#for app in apps do
	#		mentor = app.mentor
#			if (not mentor.blank?) and mentor.TPSyear == "2014"
#				if (params[:filter]=="true" and CoreMember.find(session[:user_id]).is_reader(app)) or 
#					(params[:filter].blank? or params[:filter]=="false")
#					mentors << mentor
#				end
#			end
#		end
#		@unread_mentors = []
#		@accepted_mentors = []
#		@waitlist_mentors = []
#		@rejected_mentors = []
#		for mentor in mentors
#			if mentor.status == "Accepted"
#				@accepted_mentors << mentor
#			elsif mentor.status == "Pending"
#				@unread_mentors << mentor
#			elsif mentor.status == "Waitlist"
#				@waitlist_mentors << mentor
#			elsif mentor.status == "Rejected"
#				@rejected_mentors << mentor
#			end
#		end
	end

	#def update_all_apps()
	#	if App.update_all_apps
	#		flash[:success] = "Mentee/Mentor apps updated."
	#	else 
	#		flash[:error] = "Ya done fucked up."
	#	end
	#	redirect_to :back
	#end

	def add_score()
		score = params[:score]
		reader_id = session[:user_id]
		app = App.find(params[:id])
		if reader_id.to_s == app.reader_1.to_s
			app.score_1 = score
		elsif reader_id.to_s == app.reader_2.to_s
			app.score_2 = score
		end
		if app.save
			redirect_to :back
		else
			flash[:error] = app.errors.full_messages.last
			redirect_to :back
		end
	end

	def assign()
		app = App.find(params[:id])
		cm_id = params[:app][:reader_1]
		if cm_id.blank?
			cm_id = params[:app][:reader_2]
			app.reader_2 = cm_id
		else 
			app.reader_1 = cm_id
		end

		if app.save
			redirect_to :back
		else
			flash[:error] = "Application could not be assigned. Please try again."
			redirect_to :back
		end
	end

end