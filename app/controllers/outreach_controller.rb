require 'twilio-ruby'

class OutreachController < ApplicationController
  include Webhookable

  WEBHOOK_METHODS = [:message_from_mentee_outreach, :send_mass_text]

  before_action :require_login, :except => WEBHOOK_METHODS
  after_filter :set_header, :only => WEBHOOK_METHODS
  skip_before_action :verify_authenticity_token, :only => WEBHOOK_METHODS


  #webhook for when mentees text the outreach number (Twilio)
  def message_from_mentee_outreach
    MenteeOutreachResponse.process_text(params)
    render :text => ''
  end

  def mentee_responses
    @responses = MenteeOutreachResponse.all.order(:sent_at)
  end

  def phone_numbers
    @numbers = MenteeOutreachResponse.all.map{|r| r.format_phone}
  end

  def emails
    @emails = MenteeOutreachResponse.all.map(&:email)
  end

  def export_to_csv
    filename = MenteeOutreachResponse.create_csv
    send_file Rails.root.join(filename), :x_sendfile => true
    return
  end

  def send_mass_text
    MenteeOutreachResponse.send_mass_text(params)
    render :text => 'Heyo! Congrats, your texts were sent successfully!' if MenteeOutreachResponse::AUTHORIZED_MASS_TEXT_NUMBERS.include?(params[:From])
  end

end