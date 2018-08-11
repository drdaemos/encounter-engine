import Noty from 'noty'
import "noty/src/noty.scss";
import "noty/src/themes/mint.scss";

export default class FlashMessage {
  constructor(element) {
    this.base = $(element);
    this.render();
  }

  render() {
    if (!this.base.hasClass('processed')) {
      this.base.addClass('processed')
      this.controller = new Noty({
        theme: 'mint',
        layout: 'topCenter',
        timeout: 3000,
        type: this.getType(),
        text: this.base.text()
      }).show()
    }
  }

  getType() {
    switch(this.base.data('type')) {
      case "alert":
        return "error"
      case "notice":
        return "info"
      default:
        return "warning"
    }
  }
}

document.addEventListener('DOMContentLoaded', () => {
    $('.flash-messages .message').each(function() {
      $(this).data('controller', new FlashMessage(this));
    });
})