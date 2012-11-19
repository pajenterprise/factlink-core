class InteractorEmptyView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: "fact_relations/interactor_empty"

class InteractorView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: "fact_relations/interactor"

class window.InteractorsView extends Backbone.Marionette.CompositeView
  template: "fact_relations/interactors"
  emptyView: InteractorEmptyView
  itemView: InteractorView
  itemViewContainer: "span"
  events:
    'click a.showAll' : 'showAll'

  initialize: (options) ->
    @model = new Backbone.Model
    @fetch()

  fetch: ->
    @collection.fetch success: =>
      @model.set
        numberNotDisplayed: @collection.totalRecords - @collection.length
        multipleNotDisplayed: (@collection.totalRecords - @collection.length)>1
      @render()

  templateHelpers: =>
    past_action:
      switch @collection.type
        when 'weakening'
          Factlink.Global.t.fact_disbelieve_past_action
        when 'supporting'
          Factlink.Global.t.fact_believe_past_action
        when 'doubting'
          Factlink.Global.t.fact_doubt_past_action

  showAll: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @collection.howManyPer(1000000)
    @fetch()

  insertItemSeperator: (itemView, index) ->
    if index == 1 and @collection.totalRecords == @collection.length
      itemView.$el.append ' and '
    else if index != 0
      itemView.$('a').after ','

  appendHtml: (collectionView, itemView, index) =>
    @insertItemSeperator itemView, index
    super(collectionView, itemView, index)
