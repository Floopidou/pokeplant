import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    dropImage: String
  }

  rain(event) {
    // Lancer l'animation avant de soumettre le formulaire
    this.createRain()
  }

  createRain() {
    const rainContainer = document.createElement("div")
    rainContainer.classList.add("rain-container")
    document.body.appendChild(rainContainer)

    // Créer 30 gouttes
    for (let i = 0; i < 30; i++) {
      setTimeout(() => {
        this.createDrop(rainContainer)
      }, i * 100) // Décalage de 100ms entre chaque goutte
    }

    // Supprimer le container après l'animation
    setTimeout(() => {
      rainContainer.remove()
    }, 4000)
  }

  createDrop(container) {
    const drop = document.createElement("img")
    drop.src = this.dropImageValue
    drop.classList.add("rain-drop")

    // Position horizontale aléatoire
    drop.style.left = `${Math.random() * 100}vw`

    // Taille aléatoire
    const size = 20 + Math.random() * 30
    drop.style.width = `${size}px`
    drop.style.height = `${size}px`

    // Durée aléatoire
    const duration = 1 + Math.random() * 1.5
    drop.style.animationDuration = `${duration}s`

    // Délai aléatoire
    drop.style.animationDelay = `${Math.random() * 0.5}s`

    container.appendChild(drop)

    // Supprimer la goutte après l'animation
    setTimeout(() => {
      drop.remove()
    }, (duration + 0.5) * 1000)
  }
}
