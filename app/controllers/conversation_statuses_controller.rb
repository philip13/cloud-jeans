class ConversationStatusesController < ApplicationController
  before_action :set_conversation_status, only: [ :update_status ]

  def update_status
    if @conversation_status.update(status: params[:status])
      redirect_back fallback_location: root_path, notice: "Estado actualizado correctamente."
    else
      redirect_back fallback_location: root_path, alert: "No se pudo actualizar el estado."
    end
  end

  private

  def set_conversation_status
    @conversation_status = ConversationStatus.find(params[:id])
  end
end
