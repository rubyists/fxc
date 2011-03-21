(function() {
  var p;
  p = function() {
    var _ref;
    return typeof console != "undefined" && console !== null ? (_ref = console.debug) != null ? _ref.apply(this, arguments) : void 0 : void 0;
  };
  $(function() {
    $('.actions').sortable({
      revert: true,
      handle: '.move',
      axis: 'y'
    });
    $('.new-action').draggable({
      connectToSortable: '.actions',
      helper: 'clone',
      revert: 'invalid'
    });
    $('.action .application, .action .data').blur(function(event) {
      return $('.buttons', $(event.target).closest('.action')).hide();
    });
    $('.action .buttons').hide();
    $('.action').click(function(event) {
      var action, target;
      target = $(event.target);
      action = target.closest('.action');
      $('.application, .data', action).attr('contenteditable', true);
      target.focus();
      $('.buttons', action).show();
      return false;
    });
    $('.action .buttons .ok').click(function(event) {
      var action, application, data, id, _ref;
      p("ok");
      action = $(event.target).closest('.action');
      id = parseInt(action.attr('id').split('-')[1], 10);
      _ref = [$('.application', action), $('.data', action)], application = _ref[0], data = _ref[1];
      p({
        application: application.text(),
        data: data.text(),
        action: id
      });
      return false;
    });
    return $('.action .buttons .cancel').click(function(event) {
      var action, application, data, id, _ref;
      p("cancel");
      action = $(event.target).closest('.action');
      id = parseInt(action.attr('id').split('-')[1], 10);
      _ref = [$('.application', action), $('.data', action)], application = _ref[0], data = _ref[1];
      p({
        application: application.text(),
        data: data.text(),
        action: id
      });
      return false;
    });
  });
}).call(this);
