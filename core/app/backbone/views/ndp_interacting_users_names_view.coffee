class InteractorEmptyView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: "fact_relations/interactor_empty"

class window.NDPInteractingUsersNamesView extends Backbone.Marionette.CompositeView
  template: 'fact_relations/ndp_interactors_names'
  itemView: InteractorNameView
  emptyView: InteractorEmptyView
  itemViewContainer: ".js-interactors-collection"

  events:
    'click a.js-show-all' : 'show_all'

  show_number_of_users: 2

  initialize: (options) ->
    @bindTo @collection, 'add remove reset', @render

  appendHtml: (collectionView, itemView, index) ->
    super if index < @show_number_of_users

  templateHelpers: =>
    multiplicity = if @collection.totalRecords > 1 then 'plural' else 'singular'
    translation = "fact_#{@collection.type}_present_#{multiplicity}_action"

    past_action: Factlink.Global.t[translation]
    numberNotDisplayed: => Math.max(0, @collection.totalRecords - @show_number_of_users)
    multipleNotDisplayed: => (@collection.totalRecords - @show_number_of_users) > 1

  #Possible method restrict names to one line: http://jsbin.com/esikiv/3/edit

  show_all: (e) ->
    e.stopPropagation()
    e.preventDefault()
    @show_number_of_users = Infinity
    @collection.howManyPer(1000000)
    @collection.fetch()
