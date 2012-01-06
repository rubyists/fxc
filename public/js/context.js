(function() {
  var closeEditor, loadContent, openEditor, p, postPositionUpdate, relation, selectEntry, setupLoader, sortableUpdate;
  p = function() {
    var _ref, _ref2;
    return (_ref = window.console) != null ? (_ref2 = _ref.debug) != null ? _ref2.apply(window.console, arguments) : void 0 : void 0;
  };
  openEditor = function(root, editor) {
    $('li', root.parent()).removeClass('open');
    root.addClass('open');
    editor.dialog('open');
    $('input[type=text], input[type=hidden]', editor).each(function(i, e) {
      var je, name, value;
      je = $(e);
      name = je.attr('name');
      value = $("span[class=" + name + "]", root).text();
      return je.val(value);
    });
    $('input[type=checkbox]', editor).each(function(i, e) {
      var je, name, value;
      je = $(e);
      name = je.attr('name');
      value = $("span[class=" + name + "]", root).text() === "true";
      return je.attr('checked', value);
    });
    return $('input[name=id]', editor).val(root.attr('id').split('-')[1]);
  };
  closeEditor = function(event) {
    var editor, plural;
    editor = $(event.target).closest('.editor');
    plural = editor.attr('id').split('-')[1];
    return $("#" + plural + " li").removeClass('open');
  };
  selectEntry = function(root) {
    var add, addId, name, showAll, td;
    td = root.closest('td');
    $('li', td).removeClass('active');
    root.addClass('active');
    name = td.attr('id');
    add = $("#" + name + "-add");
    addId = add.attr('id');
    showAll = false;
    return $('#browser th a').each(function(i, e) {
      var je;
      je = $(e);
      if (showAll || je.attr('id') === addId) {
        je.show();
        return showAll = true;
      } else {
        return je.hide();
      }
    });
  };
  loadContent = function(root, plural, clear) {
    var current_name, id, ul, _ref;
    _ref = root.attr('id').split('-'), current_name = _ref[0], id = _ref[1];
    ul = $("#" + plural + " ul");
    selectEntry(root);
    return $.get("/admin/context/" + plural + "/" + id + ".json", function(data) {
      var key, li, row, value, _i, _len, _results;
      clear.html('');
      _results = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        row = data[_i];
        li = $('<li>', {
          id: "" + plural + "-" + row.id
        });
        for (key in row) {
          value = row[key];
          li.append($('<span>', {
            "class": key
          }).text(value));
        }
        li.append($('<a>', {
          href: "#",
          "class": 'open-editor'
        }).html("&#x270D;"));
        _results.push(ul.append(li));
      }
      return _results;
    });
  };
  setupLoader = function(key, value) {
    return $("#" + key + " li").live('click', function(event) {
      if (value) {
        return loadContent($(event.target).closest('li'), value.open, $(value.clear));
      } else {
        return selectEntry($(event.target).closest('li'));
      }
    });
  };
  postPositionUpdate = function(li, position) {
    var id;
    id = li.attr('id').split('-')[1];
    return $.post('/admin/context/position_update', {
      id: id,
      category: li.closest('td').attr('id'),
      position: position
    });
  };
  sortableUpdate = function(event) {
    var ul;
    ul = $(event.originalEvent.target).closest('ul');
    return $('span[class=position]', ul).each(function(i, e) {
      var je, old;
      je = $(e);
      old = parseInt(je.text(), 10);
      i += 1;
      if (old !== i) {
        je.text(i);
        return postPositionUpdate(je.closest('li'), i);
      }
    });
  };
  relation = {
    contexts: {
      clear: '#extensions ul, #conditions ul, #actions ul',
      open: 'extensions'
    },
    extensions: {
      clear: '#conditions ul, #actions ul',
      open: 'conditions'
    },
    conditions: {
      clear: '#actions ul',
      open: 'actions'
    },
    actions: false
  };
  $(function() {
    var key, value;
    $('#editors .editor').dialog({
      autoOpen: false,
      width: 400,
      close: closeEditor
    });
    $('ul').sortable({
      placeholder: 'ui-state-highlight',
      update: sortableUpdate
    });
    $('ul').disableSelection();
    for (key in relation) {
      value = relation[key];
      setupLoader(key, value);
    }
    $('.open-editor').live('click', function(e) {
      var li, name, td;
      li = $(e.target).closest('li');
      td = li.closest('td');
      name = td.attr('id');
      return openEditor(li, $("#edit-" + name));
    });
    $('#browser th a').hide();
    $('#contexts-add').click(function(e) {
      var li;
      li = $('<li>');
      li.append($('<span>', {
        "class": 'name'
      }).text('New Context'));
      li.append($('<span>', {
        "class": 'description'
      }).text('New Context'));
      li.append($('<a>', {
        href: '#',
        "class": 'open-editor'
      }).html('&#x270D;'));
      $('#contexts ul').append(li);
      return false;
    });
    $('#extensions-add').click(function(e) {
      var li;
      li = $('<li>');
      li.append($('<span>', {
        "class": 'parent'
      }).text($('#contexts .active').attr('id').split('-')[1]));
      li.append($('<span>', {
        "class": 'name'
      }).text('New Extension'));
      li.append($('<span>', {
        "class": 'description'
      }).text('New Description'));
      li.append($('<a>', {
        href: '#',
        "class": 'open-editor'
      }).html('&#x270D;'));
      $('#extensions ul').append(li);
      return false;
    });
    $('#conditions-add').click(function(e) {
      var li;
      li = $('<li>');
      li.append($('<span>', {
        "class": 'parent'
      }).text($('#extensions .active').attr('id').split('-')[1]));
      li.append($('<span>', {
        "class": 'name'
      }).text('New Condition'));
      li.append($('<span>', {
        "class": 'description'
      }).text('New Condition'));
      li.append($('<a>', {
        href: '#',
        "class": 'open-editor'
      }).html('&#x270D;'));
      $('#conditions ul').append(li);
      return false;
    });
    return $('#actions-add').click(function(e) {
      var li;
      li = $('<li>');
      li.append($('<span>', {
        "class": 'parent'
      }).text($('#conditions .active').attr('id').split('-')[1]));
      li.append($('<span>', {
        "class": 'name'
      }).text('New Action'));
      li.append($('<span>', {
        "class": 'description'
      }).text('New Action'));
      li.append($('<a>', {
        href: '#',
        "class": 'open-editor'
      }).html('&#x270D;'));
      $('#actions ul').append(li);
      return false;
    });
  });
}).call(this);
