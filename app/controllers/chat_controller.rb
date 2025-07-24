class ChatController < ApplicationController
  before_action :authenticate_user!

  def index
    @phones = N8nChatHistory.list_numbers
    @chat_session_id = params[:phone] || @phones.first
    @conversation = N8nChatHistory.where(session_id: @chat_session_id).order(created_at: :asc)
  end

  def show
    @phones = N8nChatHistory.list_numbers
    @chat_session_id = params[:id]
    @conversation = N8nChatHistory.where(session_id: @chat_session_id).order(created_at: :asc)

    respond_to do |format|
      format.html { redirect_to chat_index_path(phone: @chat_session_id) }
      format.turbo_stream
    end
  end

  def check_updates
    @chat_session_id = params[:id]
    message_count = N8nChatHistory.where(session_id: @chat_session_id).count

    render json: { message_count: message_count }
  end
end
