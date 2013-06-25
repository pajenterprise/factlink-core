class ActionButtonState extends Backbone.Model
  defaults:
    checked: false
    hovering: false
    loaded: false

  onClick: ->
    if @get('checked')
      @trigger 'click:checked'
    else
      @trigger 'click:unchecked'
    @set 'hovering', false

class window.ActionButtonView extends Backbone.Marionette.ItemView
  tagName: 'button'
  template: 'generic/action_button'

  constructor: (options={}) ->
    @model = new ActionButtonState

    @className += ' btn-action btn'
    @className += ' btn-mini' if options.mini

    super

    el = options.listenToEl || @$el

    @bindTo el, 'click', @onClick, @
    @bindTo el, 'mouseenter', @onMouseEnter, @
    @bindTo el, 'mouseleave', @onMouseLeave, @

    @on 'render', @showCurrentState, @
    @bindTo @model, 'change', @render, @

  onClick: (e) ->
    e.preventDefault()
    e.stopPropagation()
    return unless @model.get('loaded')

    @model.onClick()

  onMouseEnter: -> @model.set 'hovering', true
  onMouseLeave: -> @model.set 'hovering', false

  showCurrentState: ->
    hovering = @model.get('hovering')
    checked = @model.get('checked')
    loaded = @model.get('loaded')

    @$el.toggleClass 'disabled', not loaded

    @$el.toggleClass 'btn-danger', hovering and checked and loaded
    @$el.toggleClass 'btn-primary', hovering and not checked and loaded
    @$el.toggleClass 'btn-action-checked', checked and loaded

    @trigger 'render_state', loaded, hovering, checked
