class SocialStatisticsView extends Backbone.Marionette.ItemView
  template:
    text: """
    followers: {{ followers_count }}
    following: {{ following_count }}
    """


# TODO:  Severe duplication with followChannelButtonView ! please refactor
class FollowUserButtonView extends Backbone.Marionette.Layout
  template: 'users/follow_user_button'

  events:
    "click .js-follow-user-button": "follow"
    "click .js-unfollow-user-button": "unfollow"

    "mouseleave": "disableHoverState"
    "mouseenter": "enableHoverState"

  ui:
    defaultButton:  '.js-default-state'
    hoverButton:    '.js-hover-state'
    unfollowButton: '.js-unfollow-user-button'

  initialize: ->
    @bindTo @model, 'change', @updateButton, @

    window.henk = @model

  templateHelpers: =>
    follow:    Factlink.Global.t.follow.capitalize()
    unfollow:  Factlink.Global.t.unfollow.capitalize()
    following: Factlink.Global.t.following.capitalize()

  follow: (e) ->
    @justFollowed = true
    @model.follow(@model)
    e.preventDefault()
    e.stopPropagation()

  unfollow: (e) ->
    @model.unfollow(@model)
    e.preventDefault()
    e.stopPropagation()

  onRender: -> @updateButton()

  updateButton: =>
    added = @model.get('followed?')

    @$('.js-unfollow-user-button').toggle added
    @$('.js-follow-user-button').toggle not added

  enableHoverState: ->
    return if @justFollowed
    return unless @model.get('followed?')
    @ui.defaultButton.hide()
    @ui.hoverButton.show()
    @ui.unfollowButton.addClass 'btn-danger'

  disableHoverState: ->
    delete @justFollowed
    @ui.defaultButton.show()
    @ui.hoverButton.hide()
    @ui.unfollowButton.removeClass 'btn-danger'


class window.SidebarProfileView extends Backbone.Marionette.Layout
  template: 'users/profile/sidebar_profile'

  regions:
    profilePictureRegion:   '.js-region-user-large-profile-picture'
    socialStatisticsRegion: '.js-region-user-social-statistics'
    followUserButtonRegion: '.js-region-user-follow-user'

  onRender: ->
    @profilePictureRegion.show   new UserLargeView(model: @model)
    @socialStatisticsRegion.show new SocialStatisticsView(model: @model)
    @followUserButtonRegion.show new FollowUserButtonView(model: @model)
