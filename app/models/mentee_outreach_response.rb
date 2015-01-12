require 'twilio-ruby'
require 'csv'

class MenteeOutreachResponse < ActiveRecord::Base

  TWILIO_ACCOUNT_SID = ENV['TWILIO_ACCOUNT_SID']
  TWILIO_AUTH_TOKEN = ENV['TWILIO_AUTH_TOKEN']

  CSV_FILENAME = "mentee_outreach_responses.csv"
  AUTHORIZED_MASS_TEXT_NUMBERS = ['+16509246344', '+18053055171']
  TEST_NUMBERS = ['+18053055171', '+18057045727', '+18057864756']

  ##### CLASS METHODS #####

  def self.send_mass_text(params)
    return unless AUTHORIZED_MASS_TEXT_NUMBERS.include?(params[:From])
    client = Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
    puts "from: #{params[:From]}"
    puts "message_body: #{params[:Body]}"
    MenteeOutreachResponse.find_each{|response| #TODO COMMENT IN THIS LINE
      phone_number = response.phone             #TODO COMMENT IN THIS LINE
    #TEST_NUMBERS.each{|phone_number|             #TODO COMMENT *OUT* THIS LINE
      message = client.account.messages.create(:body => params[:Body],
                                                :to => phone_number,
                                                :from => params[:To]
                                                )
    }
  end

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
    new_body = body.gsub(/email:?/i, ' ').gsub(/(\A|\s)my\s/i,' ').gsub(/(\A|\s)name\s/i, ' ').gsub(/(\A|\s)is\s/i, ' ').gsub(/(\A|\s)hello\s/i, ' ').gsub(/(\A|\s)hi\s/i, ' ').strip
    out = {}
    unless new_body.match(Helpers::EMAIL_REGEX).nil?
      out[:email] = new_body.match(Helpers::EMAIL_REGEX).to_s
      new_body = new_body.sub(Helpers::EMAIL_REGEX,'')
    end
    unless new_body.split(/\s/).blank?
      begin
        out[:first_name] = new_body.split(/\s/).first[/[a-z]+/i].strip
      rescue
        out[:first_name] = nil
      end
      begin
        out[:last_name] = new_body.sub(new_body.split(/\s/).first,'').sub(',','').strip
      rescue
        out[:last_name] = nil
      end
    end
    out
  end

  def self.process_logs
    client = Twilio::REST::Client.new(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
    list = client.account.messages.list(:to=>'+18052508140')
    messages = []

    #put all msgs in array
    while true
      list.each do |message|
        messages << message
      end
      break if list.next_page.blank?
      list = list.next_page
    end

    #process msgs in chronological order.
    messages.reverse.each{|message|
      process_log_message(message)
    }
  end

  def self.process_log_message(message)
    if MenteeOutreachResponse.where(:phone=>message.from).blank?
      parsed_body = parse_msg_body(message.body)
      m = MenteeOutreachResponse.new({
        :t_msg_id => message.sid,
        :first_name => parsed_body[:first_name],
        :last_name => parsed_body[:last_name],
        :email => parsed_body[:email],
        :phone => message.from,
        :response_type => 'text',
        :sent_at=> message.date_sent
      })
    else
      m = MenteeOutreachResponse.where(:phone=>message.from).first
      m = update_log_response(m,message)
    end
    m.save
  end

  def self.update_log_response(m,message)
    m.t_msg_id =  message.sid
    parsed_body = parse_msg_body(message.body)
    m.email = parsed_body[:email] if body_has_email?(message.body)
    m.sent_at = message.date_sent
    unless body_has_only_email?(message.body)
      m.first_name = parsed_body[:first_name]
      m.last_name = parsed_body[:last_name]
    end
    m
  end


  def self.create_csv
    fields = ['first_name', 'last_name', 'phone', 'email', 'sent_at']
    methods = ['first_name', 'last_name', 'format_phone', 'email', 'format_sent_at']
    CSV.open(Rails.root.join(CSV_FILENAME), 'w+'){ |file|
      file << fields
      self.all.each{|response|
        file << methods.map{|method| response.send(method)}
      }
    }
    CSV_FILENAME
  end

    ##### END CLASS METHODS ######



  ##### INSTANCE METHODS ######
  def format_sent_at
    time = sent_at.in_time_zone('Pacific Time (US & Canada)')
    time.strftime("%b #{time.day.ordinalize}, %-l:%M%P")
  end

  def format_phone
    out = phone.sub('+1','')
    out = out.insert(3,'-')
    out.insert(7,'-')
  end


  ##### END INSTANCE METHODS ######

end
