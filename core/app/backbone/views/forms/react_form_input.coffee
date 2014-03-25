ReactFormError = React.createBackboneClass
  displayName: 'ReactFormError'

  render: ->
    if !@model().isValid() && @model().validationError[@props.attribute]
      _span [
        'control-error'
      ],
        @model().validationError[@props.attribute]
    else
      _span []

window.ReactInput = React.createBackboneClass
  displayName: 'ReactInput'

  render: ->
    _div ['control-group'],
      _label ['control-label'],
        @props.label
      _div ['controls'],
        @transferPropsTo _input [
          value: @model().get(@props.attribute)
          onChange: (event) => @model().set @props.attribute, event.target.value
        ]
        ReactFormError model: @model(), attribute: @props.attribute
        _div ['controls-information-item'],
          @props.children
