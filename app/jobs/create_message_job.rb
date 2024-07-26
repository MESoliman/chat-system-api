class CreateMessageJob < ApplicationJob
  queue_as :default

  def perform(chat_id, message_number, message_params)
    chat = Chat.find_by(id: chat_id)

    Chat.transaction do
      # Retry loop to handle optimistic locking
      retries ||= 0
      begin
        chat.messages.create(message_params.merge(number: message_number))
        chat.increment!(:messages_count)
      rescue ActiveRecord::RecordNotUnique, ActiveRecord::StaleObjectError => e
        retries += 1
        if retries < 3
          sleep(1) # Wait before retrying
          retry
        else
          raise e
        end
      end
    end
  end
end
