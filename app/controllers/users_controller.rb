class UsersController < ApplicationController

  before_action :require_login, except: [:login]

  def login()
		user = User.find_by_login(params[:user_login])
		if user.blank?
			flash[:error] = "Sorry, the user name \"" +params[:user_login] +"\" does not exist. Please try again."
		elsif params[:password] != user.password
			flash[:error] = "Sorry, your password does not match the username provided."
		else
			session[:user_id] = user.id
		end
		redirect_to(:controller => "dashboard", :action=> "index")
	end

	def logout()
		reset_session
		flash[:message] = "You have successfully logged out."
		redirect_to(:controller=>"dashboard", :action=>"index")
	end

	def settings()
		@user = User.find(session[:user_id])
	end

	def change_password()
		user = User.find(session[:user_id])
		old_pw = params[:cur_password]
		new_pw = params[:new_password]
		confirm = params[:confirm_new_password]
		puts user.password
		puts old_pw
		if user.password != old_pw
			flash[:error] = "Sorry, your old password is incorrect."
		elsif new_pw != confirm
			flash[:error] = "Sorry, your new passwords do not match."
		elsif user.change_password(new_pw)
			flash[:success] = "Password successfully updated!"
		else
			flash[:error] = "There was an error changing your password."
		end
		redirect_to( :action=> "settings")
	end


end