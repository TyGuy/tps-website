class CommentsController < ApplicationController
	before_action :require_login

	def create()

		comment = Comment.new(
			:app_id => params[:app_id],
			:core_member_id => session[:user_id],
			:comment => params[:new_comment],
			:date_time => DateTime.now
			)
		if comment.save
			redirect_to :back
		else
			flash[:error] = "unable to add comment. " + comment.errors.full_messages.last
			redirect_to :back
		end
	end
end