class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :chat
  validates :number, presence: true, uniqueness: { scope: :chat_id }

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :body, type: :text, analyzer: :standard
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      include: {
        chat: {
          only: :number,
          include: {
            application: {
              only: :token
            }
          }
        }
      }
    )
  end

  def self.search(query, application_token, chat_number)
    __elasticsearch__.search(
      {
        query: {
          bool: {
            must: [
              {
                wildcard: {
                  "body": "*#{query}*"
                }
              },
              {
                term: {
                  "chat.application.token": application_token
                }
              },
              {
                term: {
                  "chat.number": chat_number
                }
              }
            ]
          }
        }
      }
    )
  end
end
