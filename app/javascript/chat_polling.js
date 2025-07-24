class ChatPolling {
  constructor(sessionId, pollInterval = 60000) {
    this.sessionId = sessionId;
    this.pollInterval = pollInterval;
    this.lastMessageCount = 0;
    this.isPolling = false;
  }

  start() {
    if (this.isPolling) return;
    
    this.isPolling = true;
    this.poll();
  }

  stop() {
    this.isPolling = false;
    if (this.timeoutId) {
      clearTimeout(this.timeoutId);
    }
  }

  async poll() {
    if (!this.isPolling) return;

    try {
      const response = await fetch(`/chat/${this.sessionId}/check_updates`, {
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      });

      if (response.ok) {
        const data = await response.json();
        
        if (data.message_count > this.lastMessageCount) {
          this.lastMessageCount = data.message_count;
          this.refreshChat();
        }
      }
    } catch (error) {
      console.error('Error checking for chat updates:', error);
    }

    this.timeoutId = setTimeout(() => this.poll(), this.pollInterval);
  }

  async refreshChat() {
    try {
      const response = await fetch(`/chat/${this.sessionId}`, {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      });

      if (response.ok) {
        const turboStream = await response.text();
        Turbo.renderStreamMessage(turboStream);
      }
    } catch (error) {
      console.error('Error refreshing chat:', error);
    }
  }
}

// Auto-inicializar si existe un chat activo
document.addEventListener('DOMContentLoaded', function() {
  const chatContainer = document.querySelector('[data-chat-session-id]');
  if (chatContainer) {
    const sessionId = chatContainer.dataset.chatSessionId;
    window.chatPolling = new ChatPolling(sessionId);
    window.chatPolling.start();
  }
});

// Limpiar polling al cambiar de página
document.addEventListener('turbo:before-visit', function() {
  if (window.chatPolling) {
    window.chatPolling.stop();
  }
});
