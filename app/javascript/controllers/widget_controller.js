import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails";

// Connects to data-controller="widget"
export default class extends Controller {
  connect() {
    console.log("CONNECTED TO WIDGET CONTROLLER")

    window.addEventListener("message", this.listenParentMessage)
    this.getCurrentRoom()
  }

  getCurrentRoom() {
    window.parent.postMessage({
      channel: "ACW",
      event: "get-current-room",
      payload: {
        addOnId: 8
      }
    }, "*")
  }

  listenParentMessage(e) {
    const data = e.data
    switch (data.event) {
      case "current-room":
        var path = `/appcenter/rooms/${data.data.room.id}`
        if (window.location.pathname != path) {
          Turbo.visit(path)
        }

        break;
      case "room-change":
        var path = `/appcenter/rooms/${data.data.room.id}`
        if (window.location.pathname != path) {
          Turbo.visit(path)
        }
        break;
      default:
        break;
    }
  }
}
