#TODO: check if this hide-input class thingy has some importance

# TODO: remove this, use triggers instead
window.updateWindowHeight = ->  window.updateHeight() if window.updateHeight

class window.AutoCompletedAddToChannelView extends Backbone.Marionette.Layout
  tagName: "div"
  className: "add-to-channel"
  events:
    "keydown input.typeahead": "parseKeyDown"
    "keyup input.typeahead": "autoComplete"
    "click div.fake-input": "focusInput"
    "click div.auto_complete": "addCurrentlySelectedChannel"
    "click div.fake-input a": "addCurrentlySelectedChannel"
    "click .show-input-button": "showInput"
    "mouseenter .auto_complete>div": "selectDefaultItem"

  regions:
    'added_channels': 'div.added_channels_container'
    'auto_completes': 'div.auto_complete_container'

  activeChannelKey: -> @_auto_completes_view._activeChannelKey

  setActiveChannelKey: (value) -> @_auto_completes_view._activeChannelKey = value

  template: "channels/_auto_completed_add_to_channel"

  initialize: ->
    @vent = new Backbone.Marionette.EventAggregator()
    @collection = new OwnChannelCollection()
    @_added_channels_view = new AutoCompletedAddedChannelsView(
      collection: @collection
      mainView: this
    )
    @_auto_completes_view = new AutoCompletesView(
      mainView: this
      alreadyAdded: @collection
    )

  onRender: ->
    @$(".auto_complete ul").preventScrollPropagation()

    @added_channels.show(@_added_channels_view)
    @auto_completes.show(@_auto_completes_view)

    updateWindowHeight()

  parseKeyDown: (e) ->
    @_proceed = false
    switch e.keyCode
      when 13 then @addCurrentlySelectedChannel()
      when 40 then @_auto_completes_view.moveSelectionDown()
      when 38 then @_auto_completes_view.moveSelectionUp()
      when 27 then @completelyDisappear()
      else @_proceed = true

    unless @_proceed
      e.preventDefault()
      e.stopPropagation()


  showInput: -> @$el.removeClass("hide-input").find(".fake-input input").focus()

  focusInput: -> @$("input.typeahead").focus()


  selectDefaultItem: -> console.info 'we could do something here'

  activateAutoCompleteView: (view) -> view.trigger 'requestActivate'

  deActivateAutoCompleteView: ->
    activeview = @_auto_completes_view.list[@activeChannelKey()]
    activeview.trigger "deactivate"  if activeview isnt `undefined`
    @setActiveChannelKey `undefined`

  addCurrentlySelectedChannel: ->
    @disable()
    if 0 <= @activeChannelKey() < @_auto_completes_view.list.length
      selected = @_auto_completes_view.list[@activeChannelKey()].model
      @$("input.typeahead").val selected.get("title")
      if selected.get("user_channel")
        @addNewChannel selected.get("user_channel")
        return
    @createNewChannel()

  isDupe: (title) -> @collection.where(title: title).length > 0

  createNewChannel: ->
    title = @$("input.typeahead").val()
    title = $.trim(title)
    dupe = false
    if (title.length < 1) or (@isDupe(title))
      @completelyDisappear()
      return
    to_create_user_channels = @_auto_completes_view.collection.filter((item) ->
      item.get("title") is title and item.get("user_channel")
    )
    if to_create_user_channels.length > 0
      @addNewChannel to_create_user_channels[0].get("user_channel")
      return
    $.ajax(
      url: "/" + currentUser.get("username") + "/channels"
      data:
        title: title

      type: "POST"
    ).done _.bind(@addNewChannel, this)

  addNewChannel: (channel) ->
    channel = new Channel(channel)
    currentUser.channels.add channel
    @vent.trigger "addChannel", channel
    @collection.add channel
    @completelyDisappear()

  disable: ->
    @$el.addClass("disabled").find("input.typeahead").prop "disabled", true
    @$(".btn").addClass "disabled"

  enable: ->
    @$el.removeClass("disabled").find("input.typeahead").prop "disabled", false
    @$(".btn").removeClass "disabled"


  autoComplete: ->
    searchValue = @$("input.typeahead").val()

    return  if @_lastKnownSearchValue is searchValue or not @_proceed

    @_lastKnownSearchValue = searchValue
    @setActiveChannelKey `undefined`


    @clearAutoComplete()

    return if searchValue.length < 1


    @_auto_completes_view.search_collection.setSearch searchValue
    @_auto_completes_view.search_collection.fetch success: =>
      @_auto_completes_view.setActiveAutoComplete 0
      updateWindowHeight()

  #cleaning/closing functions:

  clearAutoComplete: ->
    @_auto_completes_view.search_collection.makeEmpty()
    @$(".auto_complete").addClass "empty"

  completelyDisappear: ->
    @enable()
    @$("input.typeahead").val ""
    @$el.addClass "hide-input" if @collection.length
