window.ReactFeedSelection = React.createClass
  displayName: 'ReactFeedSelection'
  mixins: [UpdateOnSignInOrOutMixin]

  getInitialState: ->
    feedChoice: 'global'
    feeds:
      global: new GlobalFeedActivities
      personal: new PersonalFeedActivities
      discussions: new DiscussionsFeedActivities


  _handleFeedChoiceChange: (e) ->
    if(e.target.checked)
      @setState
        feedChoice: e.target.value

  render: ->
    _div [],
      if currentSession.signedIn()
        _div ['feed-selection-row'],
          _input [ 'radio-toggle-button', type: 'radio', name: 'FeedChoice', value: 'global', id: 'FeedChoice_Global', onChange: @_handleFeedChoiceChange, checked: @state.feedChoice=='global'  ]
          _label [ htmlFor: 'FeedChoice_Global' ],
            'Global'

          _input [ 'radio-toggle-button', type: 'radio', name: 'FeedChoice', value: 'personal', id: 'FeedChoice_Personal', onChange: @_handleFeedChoiceChange, checked: @state.feedChoice=='personal' ]
          _label [ htmlFor: 'FeedChoice_Personal' ],
            'Personal'
          _input [ 'radio-toggle-button', type: 'radio', name: 'FeedChoice', value: 'discussions', id: 'FeedChoice_Discussions', onChange: @_handleFeedChoiceChange, checked: @state.feedChoice=='discussions' ]
          _label [ htmlFor: 'FeedChoice_Discussions' ],
            'Discussions'

          _div ['feed-selection-install-extension-button'],
            ReactInstallExtensionOrBookmarklet()

      ReactFeedActivitiesAutoLoading
        model: @state.feeds[@state.feedChoice]
        key: @state.feedChoice
