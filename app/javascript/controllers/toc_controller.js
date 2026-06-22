import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "list"]

  connect() {
    this.buildTOC()
  }

  buildTOC() {
    if (!this.hasContentTarget || !this.hasListTarget) return

    const headings = Array.from(this.contentTarget.querySelectorAll("h2, h3"))
    
    if (headings.length === 0) return

    const html = headings.map((heading, index) => {
      // Ensure the heading has an ID
      if (!heading.id) {
        heading.id = `heading-${index}`
      }
      
      const level = heading.tagName.toLowerCase() === 'h2' ? 1 : 2
      const indentClass = level === 2 ? 'toc-indent' : ''
      
      return `
        <a href="#${heading.id}" class="toc-link ${indentClass}">
          ${heading.textContent}
        </a>
      `
    }).join("")
    
    if (this.hasListTarget) {
      this.listTarget.innerHTML = html
    }
  }
}
