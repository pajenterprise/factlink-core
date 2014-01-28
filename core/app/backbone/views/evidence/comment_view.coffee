ReactCommentReply = React.createBackboneClass
  render: ->
    count = @model().get('sub_comments_count')
    R.span {},
      "(#{count}) Reply"

class window.CommentView extends Backbone.Marionette.Layout
  className: 'evidence-argument'
  template: 'evidence/comment'

  events:
    'click .js-sub-comments-link': 'toggleSubCommentsView'

  templateHelpers: =>
    showDelete: @model.can_destroy()

  regions:
    voteRegion: '.js-vote-region'
    headingRegion: '.js-heading-region'
    subCommentsRegion: '.js-sub-comments-region'
    deleteRegion: '.js-delete-region'
    subCommentsLinkRegion: '.js-sub-comments-link-region'

  initialize: ->
    @listenTo @model, 'change:formatted_comment_content', @render

  onRender: ->
    @$el.addClass @_typeCss()
    @listenTo @model.argumentTally(), 'change', @_updateIrrelevance
    @_updateIrrelevance()
    @voteRegion.show new ReactView
      component: ReactEvidenceVote
        model: @model.argumentTally()
    @headingRegion.show new EvidenceishHeadingView model: @model.creator()

    if @model.can_destroy()
      @deleteRegion.show new ReactView
        component: ReactDeleteButton
          model: @model
          onDelete: -> @model.destroy wait: true

    @subCommentsLinkRegion.show new ReactView
      component: ReactCommentReply
        model: @model

  toggleSubCommentsView: ->
    if @subCommentsOpen
      @subCommentsOpen = false
      @subCommentsRegion.close()
    else
      @subCommentsOpen = true
      @subCommentsRegion.show new ReactView
        component: ReactSubComments
          model: new SubComments([], parentModel: @model)

  _typeCss: ->
    switch @model.get('type')
      when 'believes' then 'evidence-believes'
      when 'disbelieves' then 'evidence-disbelieves'
      when 'doubts' then 'evidence-unsure'

  _updateIrrelevance: ->
    relevant = @model.argumentTally().relevance() >= 0
    @$el.toggleClass 'evidence-irrelevant', !relevant
