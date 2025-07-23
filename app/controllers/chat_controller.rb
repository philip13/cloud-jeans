class ChatController < ApplicationController
  def index
    @phones = N8nChatHistory.list_numbers
    @conversation = N8nChatHistory.where(session_id: @phones.first).order(created_at: :asc)
    @chat_session_id = @conversation.first.session_id
  end
end
