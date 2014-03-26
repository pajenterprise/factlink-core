class FactlinkAppClass extends Backbone.Marionette.Application
  isCurrentUser: (user) ->
    @signedIn() and user.id == currentSession.user().id

  signedIn: -> !!currentSession.user().get('username')

  refreshCurrentUser: (response) ->
    if @mode == FactlinkAppMode.coreInClient
      currentSession.user().set response
    else
      # We still have some static user-dependent stuff on the site (not client)
      window.location.reload(true)

window.FactlinkApp = new FactlinkAppClass

FactlinkApp.addInitializer (options) ->
  window.currentSession = new Session
  currentSession.fetch()

  @mode = options.factlinkAppMode
  @mode(@, options)
