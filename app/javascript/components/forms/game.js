import 'foundation-datepicker/css/foundation-datepicker.min.css';
import 'foundation-datepicker';
import moment from 'moment';

export default class GameFormController {
  constructor() {
    this.render();
  }

  findForm() {
    return $('form[data-model="game"]');
  }

  findDatePickers() {
    return {
      'starts_at': $('#game_starts_at'),
      'finished_at': $('#game_finished_at'),
      'registration_deadline': $('#game_registration_deadline'),
    }
  }

  render() {
    var pickers = this.findDatePickers();
    for (var index in pickers) {
      this.initDatePicker(pickers[index]);
    }

    this.findForm().submit(this.onSubmit.bind(this));
  }

  initDatePicker(element) {
    if (element.length === 0) {
      return;
    }

    var now = this.getNowDate();
    now.setDate(now.getDate() - 1);

    if (element.val() !== '') {
      var parsedValue = moment(element.val());
      var formattedValue = parsedValue.isValid() ? parsedValue.format(this.getMomentOutputFormat()) : null;

      element.val(formattedValue);
    }

    element.fdatepicker({
        format: this.getDatePickerFormat(),
        pickTime: true,
        onRender: function (date) {
            return date < now ? 'disabled' : '';
        }
    });
  }

  onSubmit(event) {
    var pickers = this.findDatePickers();
    for (var index in pickers) {
      var value = moment(pickers[index].val(), this.getMomentOutputFormat());

      if (value.isValid()) {
          pickers[index].val(value.utc().format());
      }
    }
  }

  getDatePickerFormat() {
    return 'dd-mm-yyyy hh:ii';
  }

  getMomentOutputFormat() {
    return 'DD-MM-YYYY HH:mm';
  }

  getNowDate() {
    return new Date();
  }
}

document.addEventListener('DOMContentLoaded', () => {
    new GameFormController();
})