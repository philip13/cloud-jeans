class ConversationStatus < ApplicationRecord
  enum :status, {
    unread: "unread",
    read: "read",
    highlighted: "highlighted"
    }, validate: true

  validates :session_id, presence: true
end
