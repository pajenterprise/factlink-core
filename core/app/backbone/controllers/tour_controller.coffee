class window.TourController

  chooseChannels:  ->
    stream = window.Channels.models[0]

    visibleAddedChannels = collectionDifference(ChannelList, 'is_normal', window.Channels,
     [{is_normal: false}])

    channelCollectionView = new EditableChannelsView(collection: visibleAddedChannels)
    activities = new ChannelActivities([],{ channel: stream })
    FactlinkApp.mainRegion.show(
      new ChannelActivitiesView
        model: stream
        collection: activities)

    @suggestedUserChannels = new TopChannelList()
    @suggestedUserChannels.fetch()

    FactlinkApp.leftTopRegion.show(tourstep = new AddChannelsTourStep1())


    tourstep.on 'next', =>
        FactlinkApp.leftTopRegion.show(tourstep = new AddChannelsTourStep2())
        FactlinkApp.leftBottomRegion.show(channelCollectionView)
        FactlinkApp.leftMiddleRegion.show(
          new UserChannelSuggestionsView(
            addToCollection: window.Channels
            addToActivities: activities
            collection: @suggestedUserChannels))

        tourstep.on 'next', -> window.location = '/'