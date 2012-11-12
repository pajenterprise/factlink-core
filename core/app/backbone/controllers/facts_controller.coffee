app = FactlinkApp

class window.FactsController
  showFact: (slug, fact_id)->
    app.closeAllContentRegions()
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    fact = new Fact(id: fact_id)

    fact.fetch
      success: (model, response) => @withFact(model)

  withFact: (fact)->
    window.efv = new ExtendedFactView(model: fact)
    @main.contentRegion.show(efv)

    username = fact.get('created_by').username

    title_view = new ExtendedFactTitleView(
                        model: fact,
                        return_to_url: username,
                        return_to_text: username.capitalize() )

    @main.titleRegion.show( title_view )

    @showChannelListing(fact.get('created_by').username)

  showChannelListing: (username)->
    changed = window.Channels.setUsernameAndRefresh(username)
    channelCollectionView = new ChannelsView(collection: window.Channels)
    app.leftMiddleRegion.show(channelCollectionView)
    channelCollectionView.setActive('profile')
