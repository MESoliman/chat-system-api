class MessagesController < ApplicationController
  before_action :set_chat

  def search
    query = params[:query]

    if query.present? && params[:application_token].present? && params[:chat_number].present?
      search_results = Message.search(query, params[:application_token], params[:chat_number])
      formatted_results = search_results.records.map do |message|
        message.as_json(except: [:id, :chat_id])
      end
      render json: formatted_results
    else
      render json: { error: 'Query, application token, or chat number parameter is missing' }, status: :bad_request
    end
  end

  def create
    application = Application.find_by(token: params[:application_token])
    if application
      chat_id = chat = Chat.find_by(application_id: application.id, number: params[:chat_number])&.id
      
      if chat_id
        message_number = $redis.incr("chat:#{chat_id}:message_number")
        CreateMessageJob.perform_later(chat_id, message_number, message_params)
        render json: { number: message_number, status: 'Message created' }, status: :accepted
      else
        render json: { error: 'Chat not found' }, status: :not_found
      end
    else
      render json: { error: 'Application not found' }, status: :not_found
    end
  end

  def update
    @message = @chat.messages.find_by(number: params[:number])
    if @message.update(message_params)
      head :no_content
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  def index
    @messages = @chat.messages
    render json: @messages.map { |app| app.as_json(except: [:id, :chat_id]) }
  end

  def show
    @message = @chat.messages.find_by(number: params[:number])
    if @message
      render json: @message.as_json(except: [:id, :chat_id])
    else
      render json: { error: 'Message not found' }, status: :not_found
    end
  end

  private

  def set_chat
    @application = Application.find_by(token: params[:application_token])
    unless @application
      render json: { error: 'Application not found' }, status: :not_found
      return
    end

    @chat = @application.chats.find_by(number: params[:chat_number])
    unless @chat
      render json: { error: 'Chat not found' }, status: :not_found
    end
  end

  def message_params
    params.require(:message).permit(:body)
  end
end