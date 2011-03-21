p = ->
  console?.debug?.apply(this, arguments)

$ ->
  $('.actions').sortable(revert: true, handle: '.move', axis: 'y')
  $('.new-action').draggable(
    connectToSortable: '.actions',
    helper: 'clone',
    revert: 'invalid',
  )

  $('.action .application, .action .data').blur (event) ->
    $('.buttons', $(event.target).closest('.action')).hide()

  $('.action .buttons').hide()

  $('.action').click (event) ->
    target = $(event.target)
    action = target.closest('.action')
    $('.application, .data', action).attr('contenteditable', true)
    target.focus()
    $('.buttons', action).show()
    false

  $('.action .buttons .ok').click (event) ->
    p "ok"
    action = $(event.target).closest('.action')
    id = parseInt(action.attr('id').split('-')[1], 10)
    [application, data] = [$('.application', action), $('.data', action)]
    p application: application.text(), data: data.text(), action: id
    false

  $('.action .buttons .cancel').click (event) ->
    p "cancel"
    action = $(event.target).closest('.action')
    id = parseInt(action.attr('id').split('-')[1], 10)
    [application, data] = [$('.application', action), $('.data', action)]
    p application: application.text(), data: data.text(), action: id
    false
