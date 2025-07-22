class CreateN8nChatHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :n8n_chat_histories do |t|
      t.string :session_id, null: false, limit: 255
      t.jsonb :message, null: false

      t.index :session_id
      t.timestamps
    end
  end
end
