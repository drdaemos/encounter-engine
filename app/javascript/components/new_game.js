import 'foundation-datepicker/css/foundation-datepicker.min.css';
import 'foundation-datepicker';
import moment from 'moment';

export default class NewGameView {
  constructor() {
    this.render();
    console.log('NewGameView constructed');
  }

  findStartsAt() {
    return $('#game_starts_at');
  }

  findRegistrationDeadline() {
    return $('#game_registration_deadline');
  }

  render() {
    var now = this.getNowDate();

    var parsedStartsAt = moment(this.findStartsAt().val());

    this.findStartsAt().val(
        parsedStartsAt.format(this.getMomentOutputFormat())
    );

    this.findStartsAt().fdatepicker({
        format: this.getDatePickerFormat(),
        pickTime: true,
        onRender: function (date) {
            return date.valueOf() < now.valueOf() ? 'disabled' : '';
        }
    });

    var parsedRegistrationDeadline = moment(this.findRegistrationDeadline().val());

    this.findRegistrationDeadline().val(
        parsedRegistrationDeadline.format(this.getMomentOutputFormat())
    );

    this.findRegistrationDeadline().fdatepicker({
        format: this.getDatePickerFormat(),
        pickTime: true,
        onRender: function (date) {
            return date.valueOf() < now.valueOf() ? 'disabled' : '';
        }
    });
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
    if ($('#game_starts_at').length && $('#game_registration_deadline').length) {
        new NewGameView();
    }
})