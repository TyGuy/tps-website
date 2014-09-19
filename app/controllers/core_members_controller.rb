class CoreMembersController < ApplicationController

	before_action :require_login

	def show()
		@cm = CoreMember.find(params[:id])
	end

	def connect_to_mentor()
		begin
			cm = CoreMember.find(params[:core_member_id])
			mentor = Mentor.find(params[:mentor_id])
			cm.mentor = mentor
			mentor.core_member = cm
			cm.save
			mentor.save
		rescue
			flash[:error] = "Something went wrong."
		end
		redirect_to(:controller=>"dashboard", :action=>"index")
	end

	def show_all()
		if params[:show_all_years]
			@showing_all_years = params[:show_all_years]
		else
			@showing_all_years = false
			params[:show_all_years] = false
		end
		@cms = get_results("CoreMember",[],params)
	end

	def edit()
		@cm = CoreMember.find(params[:id])
	end

	def edit_basic()
		fn = params[:new_first_name]
		ln = params[:new_last_name]
		email = params[:new_email]
		phone = params[:new_phone]
		team = params[:new_team]
		position = params[:new_position]
		bio = params[:new_bio]
		cm = CoreMember.find(params[:id])
		cm.first_name = fn
		cm.last_name = ln
		cm.email = email
		cm.phone = phone
		cm.team = team
		cm.position = position
		cm.bio = bio

		if cm.save
			flash[:success] = "Core Team Member info successfully changed!"
			redirect_to(:action => "show",:id => cm.id)
		else
			flash[:error] = cm.errors.full_messages
			redirect_to(:action =>"edit", :id=>cm.id)
		end
	end

	def edit_cohort()
		cohort_id = params[:core_member][:cohort_id]
		cm = CoreMember.find(params[:id])
		cm.cohort_id = cohort_id
		if cm.save
			flash[:success] = "#{cm.name} successfully added to cohort."
			redirect_to(:action => "show",:id => cm.id)
		else
			flash[:error] = cm.errors.full_messages
			redirect_to(:action =>"edit", :id=>cm.id)
		end
	end

	def create()

	end

	def add()
		cm = CoreMember.new(
			:first_name => params[:new_first_name],
			:last_name => params[:new_last_name],
			:year => Constant.constants[:cur_year],
			:email => params[:new_email],
			:phone => params[:new_phone],
			:team => params[:new_team],
			:position => params[:new_position],
			:bio => params[:new_bio]
			)

		if cm.save
			User.create_if_new(cm)
			flash[:success] = "Core Team Member added. A username and password has been created for this person."
			redirect_to(:action => "show",:id => cm.id)
		else
			flash[:error] = cm.errors.full_messages
			redirect_to(:action =>"create", :id=>cm.id)
		end
	end

	def delete()
		@cm = CoreMember.find(params[:id])
		@cm.destroy
		flash[:success] = "Core Member permanently deleted from database."
		redirect_to(:action=>"show_all")
	end
	

end