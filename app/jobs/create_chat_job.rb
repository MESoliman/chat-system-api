# app/jobs/create_chat_job.rb
class CreateChatJob < ApplicationJob
  queue_as :default

  def perform(application_token, chat_number)
    application = Application.find_by(token: application_token)

    Chat.transaction do
      # Retry loop to handle optimistic locking
      retries ||= 0
      begin
        chat = application.chats.create!(number: chat_number)

        application.increment!(:chats_count)
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
