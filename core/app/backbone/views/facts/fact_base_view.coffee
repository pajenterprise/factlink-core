class window.FactBaseView extends Backbone.Marionette.Layout
  template: 'facts/fact_base'
  className: "fact-base"

  regions:
    factWheelRegion: '.fact-wheel'
    factBodyRegion: '.fact-body'

  onRender: ->
    @factWheelRegion.show @wheelView()
    @factBodyRegion.show @bodyView()

  wheelView: ->
    votes = @model.getFactVotes()

    if Factlink.Global.signed_in
      wheelView = new InteractiveWheelView
        fact: @model.attributes
        model: votes
    else
      wheelView = new BaseFactWheelView
        fact: @model.attributes
        model: votes
        respondsToMouse: false

    @listenTo @model, 'change', ->
      votes.set @model.get("fact_votes")
      wheelView.render()

    wheelView

  bodyView: ->
    @_bodyView ?= new FactBodyView
      model: @model

class FactBodyView extends Backbone.Marionette.ItemView
  template: "facts/fact_body"

  events:
    "click span.js-displaystring": "click"

  ui:
    displaystring: '.js-displaystring'

  initialize: ->
    @listenTo @model, 'change', @render

  click: (e) ->
    if e.metaKey or e.ctrlKey or e.altKey
      window.open @model.get('url'), "_blank"
    else if FactlinkApp.onClientApp
      Backbone.history.navigate @model.clientLink(), true
    else
      FactlinkApp.DiscussionModalOnFrontend.openDiscussion @model.clone(), e
