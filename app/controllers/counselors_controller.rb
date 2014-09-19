class CounselorsController < ApplicationController

	before_action :require_login

	def edit()
		@counselor = Counselor.find(params[:id])
	end

	def edit_basic()
		counselor = Counselor.find(params[:id])
		counselor.name = params[:new_name]
		counselor.email = params[:new_email]
		counselor.phone = params[:new_phone]
		if counselor.save
			flash[:success] = "Counselor successfully edited."
			redirect_to(:controller => "highschools", :action=>"show", :id => counselor.highschool_id)
		else
			flash[:error] = counselor.errors.full_messages
			redirect_to( :action => "edit", :id => params[:id])
		end
	end

	def delete()
		@counselor = Counselor.find(params[:id])
		@counselor.destroy
		flash[:success] = "Counselor permanently deleted from database."
		redirect_to(:controller => "highschools", :action=>"show", :id => @counselor.highschool_id)
	end

end