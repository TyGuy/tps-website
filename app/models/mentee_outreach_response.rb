class MenteeOutreachResponse < ActiveRecord::Base

  def self.process_text(params)
    if MenteeOutreachResponse.where(:phone=>params[:From]).count == 0
      parsed_body = parse_msg_body(params[:Body])
      m = MenteeOutreachResponse.new({
          :t_msg_id => params[:SmsMessageSid],
          :t_msg_from_city => params[:FromCity],
          :t_msg_from_zip => params[:FromZip],
          :t_msg_from_state => params[:FromState],
          :first_name => parsed_body[:first_name],
          :last_name => parsed_body[:last_name],
          :email => parsed_body[:email],
          :phone => params[:From],
          :response_type => 'text',
          :sent_at=>Time.now
      })
    else
      m = MenteeOutreachResponse.where(:phone=>params[:From]).first
      m = update_text_response(m,params)
    end
    m.save
  end

  def self.update_text_response(m,params)
    m.t_msg_id =  params[:SmsMessageSid]
    m.t_msg_from_city = params[:FromCity]
    m.t_msg_from_zip = params[:FromZip]
    m.t_msg_from_state = params[:FromState]
    parsed_body = parse_msg_body(params[:Body])
    m.email = parsed_body[:email] if body_has_email?(params[:Body])
    unless body_has_only_email?(params[:Body])
      m.first_name = parsed_body[:first_name]
      m.last_name = parsed_body[:last_name]
    end
    m
  end

  def self.body_has_email?(body)
    !body.match(Helpers::EMAIL_REGEX).nil?
  end

  def self.body_has_only_email?(body)
    !(body.strip).match(Helpers::STRICT_EMAIL_REGEX).nil?
  end

  def self.parse_msg_body(body)
    new_body = body
    out = {}
    unless new_body.match(Helpers::EMAIL_REGEX).nil?
      out[:email] = new_body.match(Helpers::EMAIL_REGEX).to_s
      new_body = new_body.sub(Helpers::EMAIL_REGEX,'')
    end
    unless new_body.split(/\s/).blank?
      out[:first_name] = new_body.split(/\s/).first[/[a-z]+/i]
      out[:last_name] = new_body.sub(new_body.split(/\s/).first,'').sub(',','')
    end
    out
  end

end
