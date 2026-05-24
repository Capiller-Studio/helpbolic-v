import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { createIcons, icons } from "lucide"

import "./cookies/cookieconsent"
import "./cookies/cookieconsent-init"

// Start Stimulus
const application = Application.start()
application.debug = false
window.Stimulus = application

// Import controllers
import controllers from "./controllers"
for (const [name, controller] of Object.entries(controllers)) {
  application.register(name, controller)
}

// Initialize Lucide icons
document.addEventListener("turbo:load", () => {
  createIcons({ icons })
})
