p = ->
  window.console?.debug(arguments ...)

Backbone.sync = Rubyists.BackboneWebSocketSync

class Model extends Backbone.Model
class Collection extends Backbone.Collection
class View extends Backbone.View

class Context extends Model
  url: 'FXC::Context'

class Contexts extends Collection
  url: 'FXC::Context::Collection'
  model: Context

class Extension extends Model
  url: 'FXC::Extension'

class Extensions extends Collection
  url: 'FXC::Extension::Collection'
  model: Extension

class Condition extends Model
  url: 'FXC::Condition'

class Conditions extends Collection
  url: 'FXC::Condition::Collection'
  model: Condition

class Browser extends View
  tagName: 'table'
  id: 'browser'

  template: _.template("""
<thead>
  <tr>
    <th>Context</th>
    <th>Extension</th>
    <th>Condition</th>
    <th>Action</th>
  </tr>
  <tbody>
    <tr>
      <td class="contexts"></td>
      <td class="extensions"></td>
      <td class="conditions"></td>
      <td class="actions"></td>
    </tr>
  </tbody>
  """)

  initialize: ->
    _.bindAll(this, 'render')
    @contextPane = new ContextPane
    @extensionPane = new ExtensionPane
    @conditionPane = new ConditionPane
    @actionPane = new ActionPane

  render: ->
    $(@el).html(@template())
    @$('.contexts').html(@contextPane.render().el)
    @$('.extensions').html(@extensionPane.render().el)
    @$('.conditions').html(@conditionPane.render().el)
    @$('.actions').html(@actionPane.render().el)
    this

  showContext: (context) ->
    context

class Pane extends View
  tagName: 'td'
  render: ->
    $(@el).html(@template())
    this

class ContextPane extends View
  tagName: 'ul'

  initialize: ->
    _.bindAll(this, 'renderOne', 'renderAll')
    @contexts = new Contexts()
    @contexts.bind('reset', @renderAll)
    @contexts.bind('change', @renderAll)
    @contexts.fetch()

  renderAll: ->
    $(@el).html('')
    @contexts.each(@renderOne)

  renderOne: (context) ->
    view = new ContextItem(pane: this, context: context)
    $(@el).append(view.render().el)

  render: ->
    @renderAll()
    this

  expand: (context) ->
    @options.browser.showContext(context)

class ContextItem extends View
  tagName: 'li'
  className: 'context'
  events: {'click': 'showContext'}
  template: _.template("""<%= name %>""")

  initialize: ->
    @context = @options.context

  render: ->
    $(@el).html(@template(name: @context.get('name')))
    this

  showContext: ->
    @options.pane.expand(@context)
    $(@el).addClass('active')

class ExtensionPane extends Pane
  id: 'extensions'
  template: _.template("""
Extension
  """)

class ConditionPane extends Pane
  id: 'conditions'
  template: _.template("""
Condition
  """)

class ActionPane extends Pane
  id: 'actions'
  template: _.template("""
Action
  """)

class Socket extends Rubyists.Socket
  onopen: ->
    browser = new Browser()
    $('#context-browser').html(browser.render().el)

$ ->
  Rubyists.syncSocket = new Socket(server: 'ws://localhost:9193')
