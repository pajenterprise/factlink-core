class window.DiscussionView extends Backbone.Marionette.Layout
  className: 'discussion'

  template: 'facts/discussion'

  regions:
    factRegion: '.js-fact-region'
    factVoteRegion: '.js-fact-vote-region'
    evidenceRegion: '.js-evidence-region'

  onRender: ->
    @listenTo @model, 'destroy', -> FactlinkApp.vent.trigger 'close_discussion_modal'

    @factRegion.show new TopFactView model: @model

    @factVoteRegion.show new FactVoteView model: @model

    evidence_collection = new EvidenceCollection null, fact: @model
    evidence_collection.fetch()

    @evidenceRegion.show new EvidenceContainerView
      collection: evidence_collection
