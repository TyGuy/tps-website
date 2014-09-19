class FeedbackSender < ActionMailer::Base
  default to: "phoenix.scholars.it@gmail.com"

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def send_feedback(user,message)
  	@user = user
  	@message = message
    @from_email = @user.email || "tsdavis@stanford.edu"
    mail( :from => @from_email,
    :subject => "TPS Website Feedback from #{@user.email}" )
  end



end
