class MassTextMessagesController < ApplicationController

  before_action :require_login

  def new
  end

  def create
    @message = MassTextMessage.new(mass_text_message_params)
    if @message.save
      flash[:success] = "Mass Text Message successfully created!"
      redirect_to mass_text_message_path(@message)
    else
      flash[:error] = "Issue creating Mass Text Message: #{@message.errors.join("\t")}"
      redirect_to new_mass_text_messages_path
    end
  end

  def update

  end

  def show
    @message = MassTextMessage.find(params[:id])
  end


  private
  def mass_text_message_params
    params.require(:mass_text_message).permit(:name, :content)
  end


end
