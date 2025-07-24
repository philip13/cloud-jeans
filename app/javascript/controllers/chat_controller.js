import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { sessionId: String, pollInterval: { type: Number, default: 30000 } }
  
  connect() {
    this.lastMessageCount = 0
    this.isPolling = false
    this.start()
  }

  disconnect() {
    this.stop()
  }

  start() {
    if (this.isPolling) return
    
    this.isPolling = true
    this.poll()
  }

  stop() {
    this.isPolling = false
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  async poll() {
    if (!this.isPolling) return

    try {
      const response = await fetch(`/chat/${this.sessionIdValue}/check_updates`, {
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })

      if (response.ok) {
        const data = await response.json()
        
        if (data.message_count > this.lastMessageCount) {
          this.lastMessageCount = data.message_count
          this.refreshChat()
        }
      }
    } catch (error) {
      console.error('Error checking for chat updates:', error)
    }

    this.timeoutId = setTimeout(() => this.poll(), this.pollIntervalValue)
  }

  async refreshChat() {
    try {
      const response = await fetch(`/chat/${this.sessionIdValue}`, {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })

      if (response.ok) {
        const turboStream = await response.text()
        Turbo.renderStreamMessage(turboStream)
      }
    } catch (error) {
      console.error('Error refreshing chat:', error)
    }
  }
}
