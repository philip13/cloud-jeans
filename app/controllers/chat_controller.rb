class ChatController < ApplicationController
  before_action :authenticate_user!

  def index
    @phones =  ConversationStatus.order(last_message_at: :desc)
    @chat_session_id = params[:phone] || @phones.first&.session_id
    @conversation = N8nChatHistory.where(session_id: @chat_session_id).order(created_at: :asc)

    @conversation_status = ConversationStatus.find_by(session_id: @chat_session_id)
  end

  def show
    @phones = ConversationStatus.order(last_message_at: :desc)
    @chat_session_id = params[:id]
    @conversation = N8nChatHistory.where(session_id: @chat_session_id).order(created_at: :asc)
    @conversation_status = ConversationStatus.find_by(session_id: @chat_session_id)

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
