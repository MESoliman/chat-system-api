class ChatsController < ApplicationController
  before_action :set_application

  def create
    application = Application.find_by(token: params[:application_token])
    if application
      chat_number = $redis.incr("application:#{application.id}:chat_number")
      CreateChatJob.perform_later(params[:application_token], chat_number)
      
      render json: { chat_number: chat_number, status: 'Chat created' }, status: :accepted
    else
      render json: { error: 'Application not found' }, status: :not_found
    end
  end

  def update
    @chat = @application.chats.find_by(number: params[:number])
    if @chat.update(chat_params)
      head :no_content
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def index
    @chats = @application.chats
    render json: @chats.map { |app| app.as_json(except: [:id, :application_id]) }
  end

  def show
    @chat = @application.chats.find_by(number: params[:number])
    if @chat
      render json: @chat.as_json(except: [:id, :application_id])
    else
      render json: { error: 'Chat not found' }, status: :not_found
    end
  end

  private

  def set_application
    @application = Application.find_by(token: params[:application_token])
    unless @application
      render json: { error: 'Application not found' }, status: :not_found
    end
  end
end

