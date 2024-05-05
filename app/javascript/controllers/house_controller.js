// app/javascript/controllers/house_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    phoneNumber: String
  }

  connect() {
    console.log("HouseController is now connected");
  }

  showPhoneNumber(event) {
    event.preventDefault();
    this.element.textContent = this.phoneNumberValue;
  }
}



