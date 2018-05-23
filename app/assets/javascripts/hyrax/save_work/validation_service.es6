export default class ValidationService {
  /**
   * @param {Form} element
   */
  constructor(form, new_work) {
    this.form = form
    this.form.on('submit', (event) => { this.checkValidationService(event, new_work) })
    this.setupAlert()
    this.readOnlyAccession(new_work)
  }

  /**
   * check the validation service before submit
   *
   */
  checkValidationService(event, new_work) {
      event.preventDefault()
      this.closeAlert()
      const url = new_work ? '/validate_new' : '/validate_edit'
      const data = this.form.serialize()

      fetch(url, {
        method: 'POST',
        body: data,
        headers: new Headers({
          'Content-Type': 'multipart/form-data'
        })
      }).then(res => res.json())
      .catch(error => console.error('Error:', error))
      .then(response => {
        if (response.error) {
          this.addError(JSON.stringify(response.error))
          this.form.find(':submit').attr('disabled', false)
        } else {
          this.form.unbind('submit').submit()
        }
      });
  }

  readOnlyAccession(new_work) {
    if (!new_work) {
      $('#image_accession_number').attr('readonly', true)
    }
  }

  setupAlert() {
    this.form.before('<div id="donut_validation" class="alert alert-danger hidden"></div>')
  }

  addError(message) {
    $('#donut_validation').html(message);
    $('#donut_validation').removeClass('hidden')
  }

  closeAlert() {
    if (!$('#donut_validation').hasClass('hidden')) {
      $('#donut_validation').addClass('hidden')
    }
  }
}
