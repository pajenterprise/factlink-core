#= require ./add_channel_to_channels_modal_view

class window.AddChannelToChannelsButtonView extends Backbone.Marionette.Layout
  template: 'channels/add_channel_to_channels_button'

  events:
    "click #add-to-channel": "openAddToChannelModal"

  initialize: ->
    @collection = @model.getOwnContainingChannels()
    @bindTo @collection, "add remove", (channel) => @updateButton()

  onRender: ->
    @updateButton()

  updateButton: =>
    added = @collection.length > 0

    @$('.added-to-channel-button-label').toggle added
    @$('.add-to-channel-button-label').toggle not added

  openAddToChannelModal: (e) ->
    e.stopImmediatePropagation()
    e.preventDefault()

    FactlinkApp.Modal.show 'Add to Channels',
      new AddChannelToChannelsModalView model: @model, collection: @collection
