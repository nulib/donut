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
      case 'genre':
        new LinkedData(element, url);
        break;
      case 'language':
        new LinkedData(element, url);
        break;
      case 'style_period':
        new LinkedData(element, url);
        break;
      case 'subject_topical':
        new LinkedData(element, url);
        break;
      case 'technique':
        new LinkedData(element, url);
        break;
      case 'subject_geographical':
        new LinkedData(element, url);
        break;
      case 'architect':
        new LinkedData(element, url);
        break;
      case 'artist':
        new LinkedData(element, url);
        break;
      case 'author':
        new LinkedData(element, url);
        break;
      case 'cartographer':
        new LinkedData(element, url);
        break;
      case 'compiler':
        new LinkedData(element, url);
        break;
      case 'composer':
        new LinkedData(element, url);
        break;
      case 'designer':
        new LinkedData(element, url);
        break;
      case 'director':
        new LinkedData(element, url);
        break;
      case 'draftsman':
        new LinkedData(element, url);
        break;
      case 'editor':
        new LinkedData(element, url);
        break;
      case 'engraver':
        new LinkedData(element, url);
        break;
      case 'illustrator':
        new LinkedData(element, url);
        break;
      case 'librettist':
        new LinkedData(element, url);
        break;
      case 'performer':
        new LinkedData(element, url);
        break;
      case 'photographer':
        new LinkedData(element, url);
        break;
      case 'presenter':
        new LinkedData(element, url);
        break;
      case 'printer':
        new LinkedData(element, url);
        break;
      case 'printmaker':
        new LinkedData(element, url);
        break;
      case 'producer':
        new LinkedData(element, url);
        break;
      case 'production_manager':
        new LinkedData(element, url);
        break;
      case 'screenwriter':
        new LinkedData(element, url);
        break;
      case 'sculptor':
        new LinkedData(element, url);
        break;
      case 'sponsor':
        new LinkedData(element, url);
        break;
      default:
        new Default(element, url);
        break;
    }
  }
}
