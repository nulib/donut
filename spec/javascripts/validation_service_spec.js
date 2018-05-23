describe("ValidationService", function() {
  var VisibilityComponent = require('hyrax/save_work/validation_service');
  var form = null;
  var target = null;

  beforeEach(function() {
    var fixture = setFixtures('<form id="edit_image">' +
        '<select><option></option></select>' +
        '<aside id="form-progress"><ul><li id="required-metadata"><li id="required-files"><li id="required-agreement"></ul>' +
        '<input type="checkbox" name="agreement" id="agreement" value="1" required="required" checked="checked" />' +
        '<input type="submit"></aside></form>');
    form = fixture.find('#edit_image');
    target = new VisibilityComponent(form, false);
  });

  it("checks validation service before submit", function() {
    spyOn(target, 'checkValidationService');
    form.trigger('submit');
    expect(target.checkValidationService).toHaveBeenCalled();
  })

});
