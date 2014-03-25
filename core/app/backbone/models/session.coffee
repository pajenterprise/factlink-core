class window.Session extends Backbone.Model
  url: -> '/api/beta/session'

  initialize: (attributes, options) ->
    @_user = new User attributes?.user

    @on 'change', @_onChange, @

  _onChange: ->
    @_user.clear silent: true
    @_user.set @get('user')
    @_user.set 'original_username', @get('user').username

  user: -> @_user
