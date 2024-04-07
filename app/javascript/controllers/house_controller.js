// app/javascript/controllers/house_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("HouseController is now connected");
  }

  static values = {
    phoneNumber: String
  }

  showPhoneNumber(event) {
    event.preventDefault()
    // Utilise la valeur phoneNumberValue pour remplacer le contenu de l'élément (le bouton) par le numéro de téléphone
    this.element.outerHTML = this.phoneNumberValue
  }
}


