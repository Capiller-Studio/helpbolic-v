import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this.debounceTimer = null
    this.selectedIndex = -1
    
    // Add event listener for click outside
    document.addEventListener("click", this.hide.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.hide.bind(this))
  }

  query(event) {
    // Keyboard navigation
    if (["ArrowDown", "ArrowUp", "Enter"].includes(event.key)) {
      event.preventDefault()
      this.navigate(event.key)
      return
    }
    
    if (event.key === "Escape") {
      this.resultsTarget.classList.add("hidden")
      return
    }

    // Normal search query debouncing
    clearTimeout(this.debounceTimer)
    this.debounceTimer = setTimeout(() => {
      this.fetchResults()
    }, 300)
  }

  navigate(key) {
    const items = this.resultsTarget.querySelectorAll("a.search-result-item")
    if (items.length === 0) return

    // Clear previous selection
    if (this.selectedIndex >= 0 && items[this.selectedIndex]) {
      items[this.selectedIndex].classList.remove("selected")
    }

    if (key === "ArrowDown") {
      this.selectedIndex = (this.selectedIndex + 1) % items.length
    } else if (key === "ArrowUp") {
      this.selectedIndex = (this.selectedIndex - 1 + items.length) % items.length
    } else if (key === "Enter") {
      if (this.selectedIndex >= 0 && items[this.selectedIndex]) {
        window.location.href = items[this.selectedIndex].href
      } else {
        // Fallback: submit full search page if they press enter without selecting
        const query = this.inputTarget.value.trim()
        if (query.length >= 2) {
          window.location.href = `/search?query=${encodeURIComponent(query)}`
        }
      }
      return
    }

    // Apply new selection
    if (this.selectedIndex >= 0 && items[this.selectedIndex]) {
      items[this.selectedIndex].classList.add("selected")
      // Update input value (optional UX choice)
      // this.inputTarget.value = items[this.selectedIndex].textContent.trim()
    }
  }

  async fetchResults() {
    const query = this.inputTarget.value.trim()
    
    if (query.length < 2) {
      this.resultsTarget.classList.add("hidden")
      this.selectedIndex = -1
      return
    }

    try {
      const response = await fetch(`/search/suggestions?query=${encodeURIComponent(query)}`, {
        headers: { "Accept": "application/json" }
      })
      
      if (!response.ok) throw new Error("Search failed")
      
      const data = await response.json()
      this.renderResults(data)
    } catch (error) {
      console.error(error)
    }
  }

  renderResults(data) {
    this.selectedIndex = -1 // Reset selection
    
    if (data.articles.length === 0 && data.categories.length === 0) {
      this.resultsTarget.innerHTML = `<div class="search-empty">No results found.</div>`
    } else {
      let html = ""
      
      if (data.categories.length > 0) {
        html += `<div class="search-dropdown-label">COLLECTIONS</div>`
        html += data.categories.map(cat => `
          <a href="${cat.url}" class="search-result-item">
            <svg class="search-result-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
            </svg>
            <div class="search-result-title">${cat.name}</div>
          </a>
        `).join("")
      }
      
      if (data.articles.length > 0) {
        html += `<div class="search-dropdown-label">ARTICLES</div>`
        html += data.articles.map(art => `
          <a href="${art.url}" class="search-result-item">
            <svg class="search-result-icon" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
            </svg>
            <div class="search-result-title">${art.title}</div>
          </a>
        `).join("")
      }
      
      const query = this.inputTarget.value.trim()
      html += `
        <div class="search-dropdown-footer">
          <a href="/search?query=${encodeURIComponent(query)}" class="search-view-all">View all results for "${query}" &rarr;</a>
        </div>
      `
      
      this.resultsTarget.innerHTML = html
    }
    
    this.resultsTarget.classList.remove("hidden")
  }

  // Click outside to hide
  hide(event) {
    if (!this.element.contains(event.target)) {
      this.resultsTarget.classList.add("hidden")
    }
  }
}
