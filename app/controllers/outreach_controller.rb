require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  #webhook for when mentees text the outreach number
  def message_from_mentee_outreach
    MenteeOutreachResponse.process_text(params)
    render text: ''
  end

end