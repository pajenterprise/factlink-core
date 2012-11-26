# WARNING: model is reset, so don't bind on it.
class window.FactRelationPreviewView extends Backbone.Marionette.Layout
  className: 'fact-relation-preview-view'
  template: 'fact_relations/preview'

  regions:
    factBaseRegion: '.fact-base-region'

  events:
    'click .js-cancel': 'onCancel'
    'click .js-post': 'onPost'

  onRender: ->
    @factBaseRegion.show new FactBaseView
      model: @model

  onCancel: -> @trigger 'cancel'

  onPost: -> @trigger 'createFactRelation', @model
