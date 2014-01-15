class AutoCompleteResultsChannelView extends Backbone.Marionette.ItemView
  tagName: "li"
  className: 'auto-complete-result-item'

  triggers:
    "click a.icon-remove": "remove"

  template: "channels/auto_complete_results_channel"

class window.AutoCompleteResultsChannelsView extends Backbone.Marionette.CollectionView
  itemView:  AutoCompleteResultsChannelView
  tagName: 'ul'

  initialize: ->
    @on "itemview:remove", (childView, msg) => @collection.remove childView.model
