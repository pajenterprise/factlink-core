class NDPEvidenceVoteView extends Backbone.Marionette.ItemView

  _.extend @prototype, Backbone.Factlink.PopoverMixin

  template:
    text: """
      <a class="evidence-impact-vote-up js-up"></a>
      <a class="evidence-impact-vote-down js-down"></a>
    """

  events:
    "click .js-up": "_on_up_vote"
    "click .js-down":  "_on_down_vote"

  initialize: ->
    @bindTo @model, "change", @render, @

  onRender: ->
    @$('a.js-up').addClass('active')    if @model.get('current_user_opinion') == 'believes'
    @$('a.js-down').addClass('active')  if @model.get('current_user_opinion') == 'disbelieves'

  _on_up_vote: ->
    mp_track "Factlink: Upvote evidence click"
    if @model instanceof FactRelation && Factlink.Global.can_haz['vote_up_down_popup']
      @open_vote_popup '.js-up', FactRelationVoteUpView
    else
      if @model.isBelieving()
        @model.removeOpinion()
      else
        @model.believe()

  _on_down_vote: ->
    mp_track "Factlink: Downvote evidence click"
    if @model instanceof FactRelation && Factlink.Global.can_haz['vote_up_down_popup']
      @open_vote_popup '.js-down',  FactRelationVoteDownView
    else
      if @model.isDisBelieving()
        @model.removeOpinion()
      else
        @model.disbelieve()

  open_vote_popup: (selector, view_klass) ->
    return if @popoverOpened selector

    @popoverResetAll()
    @popoverAdd selector,
      side: if @model.get('type') == 'believes' then 'left' else 'right'
      align: 'top'
      fadeTime: 40
      contentView: @bound_popup_view view_klass

  bound_popup_view: (view_klass) ->
    view = new view_klass model: @model

    @bindTo view, 'saved', =>
      @popoverResetAll()

    view


class NDPEvidenceLayoutView extends Backbone.Marionette.Layout
  template: 'evidence/ndp_evidence_layout'

  regions:
    contentRegion: '.js-content-region'
    voteRegion: '.js-vote-region'

  typeCss: ->
    switch @model.get('type')
      when 'believes' then 'evidence-supporting'
      when 'disbelieves' then 'evidence-weakening'
      when 'doubts' then 'evidence-unsure'

  render: ->
    super
    @$el.addClass @typeCss()
    this


class NDPVotableEvidenceLayoutView extends NDPEvidenceLayoutView
  className: 'evidence-votable'

  onRender: ->
    @contentRegion.show new NDPFactRelationOrCommentView model: @model

    if Factlink.Global.signed_in
      @voteRegion.show new NDPEvidenceVoteView model: @model
      @$el.addClass 'evidence-has-arrows'


class NDPOpinionatorsEvidenceLayoutView extends NDPEvidenceLayoutView

  shouldShow: -> @model.has('impact') && @model.get('impact') > 0.0

  onRender: ->
    @$el.toggle @shouldShow()
    @contentRegion.show new InteractingUsersView model: @model


class NDPEvidenceLoadingView extends Backbone.Marionette.ItemView
  className: "evidence-loading"
  template: 'evidence/ndp_evidence_loading_indicator'


class NDPEvidenceEmptyLoadingView extends Backbone.Factlink.EmptyLoadingView
  loadingView: NDPEvidenceLoadingView


class window.NDPEvidenceCollectionView extends Backbone.Marionette.CompositeView
  className: 'evidence-collection'
  template: 'evidence/ndp_evidence_collection'
  itemView: NDPEvidenceLayoutView
  itemViewContainer: '.js-evidence-item-view-container'
  emptyView: NDPEvidenceEmptyLoadingView


  itemViewOptions: ->
    collection: @collection

  showCollection: ->
    if @collection.loading()
      @showEmptyView()
    else
      super

  getItemView: (item) ->
    if item instanceof OpinionatersEvidence
      NDPOpinionatorsEvidenceLayoutView
    else
      NDPVotableEvidenceLayoutView
