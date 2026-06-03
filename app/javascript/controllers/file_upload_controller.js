import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "empty", "summary", "list"]

  update() {
    const files = Array.from(this.inputTarget.files)

    this.emptyTarget.classList.toggle("hidden", files.length > 0)
    this.summaryTarget.classList.toggle("hidden", files.length === 0)

    this.listTarget.replaceChildren(
      ...files.map((file) => this.buildFileItem(file))
    )
  }

  buildFileItem(file) {
    const item = document.createElement("li")
    item.className = "upload-file-item"

    const name = document.createElement("span")
    name.className = "upload-file-name"
    name.textContent = file.name

    const size = document.createElement("span")
    size.className = "upload-file-size"
    size.textContent = this.formatSize(file.size)

    item.append(name, size)
    return item
  }

  formatSize(bytes) {
    if (bytes < 1024) return `${bytes} B`
    if (bytes < 1024 * 1024) return `${Math.round(bytes / 1024)} KB`

    return `${(bytes / 1024 / 1024).toFixed(1)} MB`
  }
}