class TopFactEvidenceLayoutView extends Backbone.Marionette.Layout
  template: 'evidence/top_fact_evidence_layout'

  regions:
    contentRegion: '.js-content-region'

  templateHelpers:
    type_css: ->
      switch @type
        when 'believe' then 'supporting'
        when 'disbelieve' then 'weakening'
        when 'doubt' then 'unsure'

    is_unsure: -> @type == 'doubt'

  onRender: ->
    @$el.toggle @model.get('impact') != ''
    @contentRegion.show new InteractingUsersView model: @model

class window.TopFactEvidenceView extends Backbone.Marionette.CompositeView
  className: 'top-fact-evidence'
  template: 'evidence/top_fact_evidence'
  itemView: TopFactEvidenceLayoutView
  itemViewContainer: '.js-evidence-item-view-container'

  initialize: ->
    @bindTo @collection, 'change:impact', @render
