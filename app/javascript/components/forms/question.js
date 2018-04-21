import 'foundation-datepicker/css/foundation-datepicker.min.css';
import 'foundation-datepicker';
import moment from 'moment';

export default class QuestionEditView {
  constructor() {
    this.render();
  }

  render() {
    QuestionEditView.findDependentFields().each(function () {
      let field = this;
      let targetSelector = $(field).data('dependent-on');
      let target = document.getElementById(targetSelector);

      $(target).change(function (ev) {
        QuestionEditView.onDependencyChange(field, QuestionEditView.getInputValue(ev.target))
      });

      QuestionEditView.onDependencyChange(field, QuestionEditView.getInputValue(target));
    })

    QuestionEditView.findForm().submit(this.onSubmit.bind(this));
  }

  static findForm() {
    return $('form[data-model="question"]');
  }

  static findDependentFields() {
    return QuestionEditView.findForm().find('.dependent')
  }

  static getInputValue (input) {
    if (input.getAttribute('type') === 'checkbox') {
      return input.checked
    }

    return $(input).val()
  }

  static onDependencyChange (dependent, value) {
    let condition = $(dependent).data('dependent-show-when');

    // TODO: parse condition as JSON, because eval is considered evil, yeah, i know.
    if (value === eval(condition)) {
      $(dependent).addClass('dependent-visible');
    } else {
      $(dependent).removeClass('dependent-visible');
    }
  }

  onSubmit(event) {
  }
}

document.addEventListener('DOMContentLoaded', () => {
  new QuestionEditView();
})