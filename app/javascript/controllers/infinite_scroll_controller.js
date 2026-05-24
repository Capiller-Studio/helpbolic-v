import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"

export default class extends Controller {
  connect() {
    this.observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.loadMore()
        }
      })
    }, {
      rootMargin: "200px",
    })
    this.observer.observe(this.element)
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  async loadMore(event) {
    if (event) {
      event.preventDefault()
    }
    
    // Prevent multiple fetches while loading
    if (this.isLoading) return
    this.isLoading = true
    
    // Update UI to show loading
    const originalText = this.element.innerHTML
    this.element.innerHTML = '<span class="loading-spinner"></span> Loading...'
    this.element.style.pointerEvents = 'none'
    this.element.style.opacity = '0.7'
    
    const url = this.element.href
    await get(url, { responseKind: "turbo-stream" })
  }
}
