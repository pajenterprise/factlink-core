class window.ChannelsController extends Backbone.Factlink.CachingController

  routes: ['getChannelFacts', 'getChannelFact', 'getChannelActivities', 'getChannelFactForActivity', 'getTopicFacts', 'getTopicFact']

  loadTopic: (slug_title, callback) ->
    topic = new Topic {slug_title}
    topic.fetch success: (model) -> callback(model)
    topic

  restoreTopicView: (slug_title, new_callback) ->
    @restoreCachedView "topic-#{slug_title}", new_callback

  showSidebarForTopic: (topic) ->
    FactlinkApp.leftBottomRegion.close()
    @showUserProfile currentUser
    window.Channels.setUsernameAndRefreshIfNeeded currentUser.get('username') # TODO: check if this can be removed
    FactlinkApp.Sidebar.showForTopicsAndActivateCorrectItem(topic)

  getTopicFacts: (slug_title) ->
    FactlinkApp.mainRegion.show(@cached_views)

    @loadTopic slug_title, (topic) =>
      @showSidebarForTopic(topic)
      @restoreTopicView slug_title, => new TopicView model: topic
      @makePermalinkEvent(topic.url())

  getTopicFact: (slug_title, fact_id, params={}) ->
    topic = @loadTopic slug_title,
      => @showSidebarForTopic topic
    back_button = new TopicBackButton [], model: topic

    FactlinkApp.mainRegion.show new DiscussionPageView
      model: new Fact(id: fact_id)
      back_button: back_button
      tab: params.tab

  loadChannel: (username, channel_id, callback) ->
    channel = Channels.get(channel_id)

    mp_track("mp_page_view", {mp_page: window.location.href})

    if (channel)
      callback(channel)
    else
      channel = new Channel created_by: {username: username}, id: channel_id
      channel.fetch
        success: -> callback(channel)

    channel

  showSidebarForChannel: (channel) ->
    user = channel.user()
    @showUserProfile user
    window.Channels.setUsernameAndRefreshIfNeeded user.get('username') # TODO: check if this can be removed
    FactlinkApp.Sidebar.showForChannelsOrTopicsAndActivateCorrectItem window.Channels, channel, user

  showUserProfile: (user)->
    if user.is_current_user()
      FactlinkApp.leftTopRegion.close()
    else
      userView = new UserView(model: user)
      FactlinkApp.leftTopRegion.show(userView)

  getChannelFacts: (username, channel_id) ->
    FactlinkApp.mainRegion.show(@cached_views)

    @loadChannel username, channel_id, (channel) =>
      @showSidebarForChannel(channel)
      @makePermalinkEvent(channel.url())

      @restoreCachedView channel_id, => new ChannelView(model: channel)

  # TODO: this is only ever used for the stream,
  #       don't act like this is a general function
  getChannelActivities: (username, channel_id) ->
    # getStream
    FactlinkApp.leftTopRegion.close()

    FactlinkApp.mainRegion.show(@cached_views)

    @loadChannel username, channel_id, (channel) =>
      @showSidebarForChannel(channel)
      FactlinkApp.Sidebar.activate('stream')
      @makePermalinkEvent(channel.url() + '/activities')

      @restoreCachedView channel_id, =>
        activities = new ChannelActivities([],{ channel: channel })
        new ChannelActivitiesView(model: channel, collection: activities)

  getChannelFactForActivity: (username, channel_id, fact_id) ->
    @getChannelFact(username, channel_id, fact_id, for_stream: true)

  getChannelFact: (username, channel_id, fact_id, params={}) ->
    channel = @loadChannel username, channel_id, (channel) => @showSidebarForChannel channel
    back_button = new ChannelBackButton [], model: channel, for_stream: params.for_stream

    FactlinkApp.mainRegion.show new DiscussionPageView
      model: new Fact(id: fact_id)
      back_button: back_button
      tab: params.tab
