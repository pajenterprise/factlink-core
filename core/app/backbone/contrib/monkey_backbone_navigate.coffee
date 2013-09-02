# We want an event whenever we change the url of
# the page
old_navigate = Backbone.History.prototype.navigate
new_navigate = (fragment, options) ->
  fragment = Backbone.history.getFragment(fragment)
  FactlinkApp.vent.trigger 'navigate', fragment
  old_navigate.apply @, arguments

Backbone.History.prototype.navigate = new_navigate


# We also want an event when a new url is loaded,
# e.g. when navigating using the browser
old_loadUrl = Backbone.History.prototype.loadUrl
new_loadUrl = (fragment) ->
  fragment = Backbone.history.getFragment(fragment)
  return if FactlinkApp.DiscussionModalOnFrontend.loadUrlStopRouting(fragment)
  FactlinkApp.vent.trigger 'load_url', fragment
  old_loadUrl.apply @, arguments

Backbone.History.prototype.loadUrl = new_loadUrl
