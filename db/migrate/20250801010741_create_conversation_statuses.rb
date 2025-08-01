class CreateConversationStatuses < ActiveRecord::Migration[8.0]
  def change
    create_table :conversation_statuses do |t|
      t.string :session_id, null: false
      t.string :status, null: false, default: 'unread'
      t.text :last_message
      t.datetime :last_message_at
      t.timestamps

      t.index :session_id, unique: true
      t.index :status
      t.index :last_message_at
    end
  end
end
