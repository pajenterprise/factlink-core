class window.DeleteButtonView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'delete-button'

  template: 'buttons/delete_button'

  events:
    'click .js-first': '_toggleButton'
    'mouseleave': '_closeButton'

  triggers:
    'click .js-second': 'delete'

  onRender: ->
    if @options.opened
      @$el.addClass 'delete-button-open'

  _toggleButton: ->
    @$el.toggleClass 'delete-button-open'

  _closeButton: ->
    @$el.removeClass 'delete-button-open'
