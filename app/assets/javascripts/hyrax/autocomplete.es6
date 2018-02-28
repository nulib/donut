import Default from './autocomplete/default';
import Resource from './autocomplete/resource';
import LinkedData from './autocomplete/linked_data';

export default class Autocomplete {
  /**
   * Setup for the autocomplete field.
   * @param {jQuery} element - The input field to add autocompete to
   * @param {string} fieldName - The name of the field (e.g. 'based_near')
   * @param {string} url - The url for the autocompete search endpoint
   */
  setup(element, fieldName, url) {
    switch (fieldName) {
      case 'work':
        new Resource(element, url, { excluding: element.data('exclude-work') });
        break;
      case 'collection':
        new Resource(element, url);
        break;
      case 'based_near':
        new LinkedData(element, url);
        break;
      case 'contributor_role':
        new LinkedData(element, url);
        break;
      case 'genre':
        new LinkedData(element, url);
        break;
      case 'language':
        new LinkedData(element, url);
        break;
      case 'style_period':
        new LinkedData(element, url);
        break;
      case 'subject':
        new LinkedData(element, url);
        break;
      case 'technique':
        new LinkedData(element, url);
        break;
      default:
        new Default(element, url);
        break;
    }
  }
}
