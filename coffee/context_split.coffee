p = ->
  window.console?.debug?.apply(window.console, arguments)

openEditor = (root, editor) ->
  $('li', root.parent()).removeClass('open')
  root.addClass('open')

  editor.dialog('open')

  $('input[type=text], input[type=hidden]', editor).each (i, e) ->
    je = $(e)
    name = je.attr('name')
    value = $("span[class=#{name}]", root).text()
    je.val(value)

  $('input[type=checkbox]', editor).each (i, e) ->
    je = $(e)
    name = je.attr('name')
    value = $("span[class=#{name}]", root).text() == "true"
    je.attr('checked', value)

  $('input[name=id]', editor).val(root.attr('id').split('-')[1])

closeEditor = (event) ->
  editor = $(event.target).closest('.editor')
  plural = editor.attr('id').split('-')[1]
  $("##{plural} li").removeClass('open')

selectEntry = (root) ->
  td = root.closest('td')
  $('li', td).removeClass('active')
  root.addClass('active')
  name = td.attr('id')
  add = $("##{name}-add")
  addId = add.attr('id')
  showAll = false
  $('#browser th a').each (i, e) ->
    je = $(e)
    if showAll || je.attr('id') == addId # show all from here on
      je.show()
      showAll = true
    else
      je.hide()

loadContent = (root, plural, clear) ->
  [current_name, id] = root.attr('id').split('-')
  ul = $("##{plural} ul")

  selectEntry root

  $.get "/admin/#{plural}/#{id}.json", (data) ->
    clear.html('')
    for row in data
      li = $('<li>', id: "#{plural}-#{row.id}")
      for key, value of row
        li.append($('<span>', class: key).text(value))
      li.append($('<a>', href: "#", class: 'open-editor').html("&#x270D;"))
      ul.append(li)

setupLoader = (key, value) ->
  $("##{key} li").live 'click', (event) ->
    if value
      loadContent $(event.target).closest('li'), value.open, $(value.clear)
    else
      selectEntry $(event.target).closest('li')

postPositionUpdate = (li, position) ->
  id = li.attr('id').split('-')[1]
  $.post '/admin/position_update', {
    id: id,
    category: li.closest('td').attr('id'),
    position: position,
  }

# TODO: position is not continuous, so on the first change we'll POST all
#       items.  while that's not a fatal bug, it's a lot of useless traffic,
#       unfortunately sequel doesn't seem to care.
sortableUpdate = (event) ->
  ul = $(event.originalEvent.target).closest('ul')
  $('span[class=position]', ul).each (i, e) ->
    je = $(e)
    old = parseInt(je.text(), 10)
    i += 1
    unless old == i
      je.text(i)
      postPositionUpdate(je.closest('li'), i)

relation = {
  contexts:   { clear: '#extensions ul, #conditions ul, #actions ul', open: 'extensions' },
  extensions: { clear: '#conditions ul, #actions ul', open: 'conditions'},
  conditions: { clear: '#actions ul', open: 'actions' },
  actions:    false,
}

$ ->
  $('#editors .editor').dialog(
    autoOpen: false,
    width: 400,
    close: closeEditor,
  )

  $('ul').sortable(
    placeholder: 'ui-state-highlight',
    update: sortableUpdate,
  )
  $('ul').disableSelection()

  setupLoader(key, value) for key, value of relation
        
  $('.open-editor').live 'click', (e) ->
    li = $(e.target).closest('li')
    td = li.closest('td')
    name = td.attr('id')
    openEditor(li, $("#edit-#{name}"))

  $('#browser th a').hide()

  $('#contexts-add').click (e) ->
    li = $('<li>')
    li.append($('<span>', class: 'name').text('New Context'))
    li.append($('<span>', class: 'description').text('New Context'))
    li.append($('<a>', href: '#', class: 'open-editor').html('&#x270D;'))
    $('#contexts ul').append(li)
    false

  $('#extensions-add').click (e) ->
    li = $('<li>')
    li.append($('<span>', class: 'parent').text($('#contexts .active').attr('id').split('-')[1]))
    li.append($('<span>', class: 'name').text('New Extension'))
    li.append($('<span>', class: 'description').text('New Description'))
    li.append($('<a>', href: '#', class: 'open-editor').html('&#x270D;'))
    $('#extensions ul').append(li)
    false

  $('#conditions-add').click (e) ->
    li = $('<li>')
    li.append($('<span>', class: 'parent').text($('#extensions .active').attr('id').split('-')[1]))
    li.append($('<span>', class: 'name').text('New Condition'))
    li.append($('<span>', class: 'description').text('New Condition'))
    li.append($('<a>', href: '#', class: 'open-editor').html('&#x270D;'))
    $('#conditions ul').append(li)
    false

  $('#actions-add').click (e) ->
    li = $('<li>')
    li.append($('<span>', class: 'parent').text($('#conditions .active').attr('id').split('-')[1]))
    li.append($('<span>', class: 'name').text('New Action'))
    li.append($('<span>', class: 'description').text('New Action'))
    li.append($('<a>', href: '#', class: 'open-editor').html('&#x270D;'))
    $('#actions ul').append(li)
    false
