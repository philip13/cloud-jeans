import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { sessionId: String, pollInterval: { type: Number, default: 30000 } }
  
  async connect() {
    this.lastMessageCount = 0
    this.isPolling = false
    console.log(`Chat controller connected for session ${this.sessionIdValue} with polling interval ${this.pollIntervalValue}ms`)
    
    // Inicializar el contador actual de mensajes
    await this.initializeMessageCount()
    
    this.start()
  }

  disconnect() {
    this.stop()
  }

  async initializeMessageCount() {
    try {
      const response = await fetch(`/chat/${this.sessionIdValue}/check_updates`, {
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })

      if (response.ok) {
        const data = await response.json()
        this.lastMessageCount = data.message_count
        console.log('Initialized message count:', this.lastMessageCount)
      }
    } catch (error) {
      console.error('Error initializing message count:', error)
    }
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
        console.log(`Polling check - Current: ${data.message_count}, Last: ${this.lastMessageCount}`)
        if (data.message_count > this.lastMessageCount) {
          console.log(`New messages detected: ${this.lastMessageCount} -> ${data.message_count}`)
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
      console.log('Refreshing chat for session:', this.sessionIdValue)
      const response = await fetch(`/chat/${this.sessionIdValue}`, {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        }
      })

      if (response.ok) {
        const turboStream = await response.text()
        console.log('Received turbo stream, updating DOM')
        Turbo.renderStreamMessage(turboStream)
        
        // Scroll to bottom after update
        setTimeout(() => {
          const chatContainer = this.element
          if (chatContainer) {
            chatContainer.scrollTop = chatContainer.scrollHeight
          }
        }, 100)
      } else {
        console.error('Failed to refresh chat:', response.status, response.statusText)
      }
    } catch (error) {
      console.error('Error refreshing chat:', error)
    }
  }
}
