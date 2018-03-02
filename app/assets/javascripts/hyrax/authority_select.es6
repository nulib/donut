import Autocomplete from 'hyrax/autocomplete';

/** Class for authority selection on an input field */
export default class AuthoritySelect {
  /**
   * Create an AuthoritySelect
   * @param {Editor} editor - The parent container
   * @param {string} selectBox - The selector for the select box
   * @param {string} inputField - The selector for the input field
   */
  constructor(options) {
    this.selectBox = options.selectBox;
    this.inputField = options.inputField;
    // Is this authority select dropdown using controlled vocabulary?
    this.usesControlledVocab = options.usesControlledVocab;

    this.selectBoxChange();
    this.observeAddedElement();
    if (!this.usesControlledVocab) {
      this.setupAutocomplete();
    }
  }

  /**
   * Bind behavior for select box
   */
  selectBoxChange() {
    const selectBox = this.selectBox;
    const inputField = this.inputField;
    let _this2 = this;
    $(selectBox).on('change', function(data) {
      const selectBoxValue = $(this).val();

      $(inputField).each(function(data, el) {
        const key = $(el).data('attribute');
        const $wrapperEl = $(el).closest('[data-field-name="' + key + '"]');

        // Update element's autocomplete attribute
        $(this).attr('data-autocomplete-url', selectBoxValue);
        // Update element's wrapper autocomplete attribute
        $wrapperEl.attr('data-autocomplete-url', selectBoxValue);

        _this2.setupAutocomplete();
      });
    });
  }

  /**
   * Create an observer to watch for added input elements
   */
  observeAddedElement() {
    var selectBox = this.selectBox;
    var inputField = this.inputField;
    var _this2 = this;

    var observer = new MutationObserver(mutations => {
      mutations.forEach(mutation => {
        $(inputField).each(function(data) {
          // TODO: Does this actually work explicity on the DOM,
          // or was it specifically setup to work in memory?
          $(this).data('autocomplete-url', $(selectBox).val());
          _this2.setupAutocomplete();
        });
      });
    });

    var config = { childList: true };
    observer.observe(document.body, config);
  }

  /**
   * intialize the Hyrax autocomplete with the fields that you are using
   */
  setupAutocomplete() {
    // Deny this setupAutocomplete() call if using controlled vobab, otherwise repeatedly calling
    // autocomplete results in infinite loop.  Why are we repeatedly calling autocomplete
    // after each dropdown change?  Seems like overkill maybe?
    if (this.usesControlledVocab) {
      return;
    }

    const $inputField = $(this.inputField);
    const autocomplete = new Autocomplete();
    autocomplete.setup(
      $inputField,
      $inputField.attr('data-autocomplete'),
      $inputField.attr('data-autocomplete-url')
    );
  }
}
