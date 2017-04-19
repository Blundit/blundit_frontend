{ div, a } = React.DOM

InlineLink = require("components/InlineLink")

module.exports = React.createFactory React.createClass
  getInitialState: ->
    url: ''
    addBonaFideError: false
    submittingBonaFide: false


  addBonaFide: ->
    if @state.url == ''
      @setState addBonaFideError: "Url required"
      return

    params = {
      path: "add_bona_fide"
      path_variables:
        expert_id: @props.expert.id
      data:
        url: @state.url

      success: @addBonaFidesSuccess
      error: @addBonaFidesError
    }

    API.call(params)

  
  addBonaFidesSuccess: (data) ->
    @setState url: ''
    @setState submittingBonaFide: false
    @props.refresh()


  addBonaFidesError: (error) ->
    @setState submittingBonaFide: false
    if error.responseJSON? and error.responseJSON.errors?
      @setState addBonaFideError: error.responseJSON.errors[0]
    else
      @setState addBonaFideError: "There was an error."

  
  changeURL: (event) ->
    @setState url: event.target.value


  render: ->
    @refreshStyle = {
      display: 'inline-block'
      position: 'relative'
      boxShadow: 'none'
    }

    { bona_fides } = @props.expert

    div { className: "default__card" },
      div { className: "text__title" },
        "Credentials"
      div { className: "expert__bona-fides" },
        if bona_fides.length == 0
          div { className: "not-found" },
            "This expert currently has no credentials."
        else
          bona_fides.map (bona_fide, index) ->
            InlineLink
              item: bona_fide
              key: "expert-bona-fide-#{index}"
      if UserStore.loggedIn()
        if @state.submittingBonaFide == true
          React.createElement(Material.RefreshIndicator, { style: @refreshStyle, size: 50, left: 0, top: 0, status:"loading" })
        else
          div { className: "expert__bona-fide__add" },
            React.createElement(Material.TextField,
              {
                value: @state.url,
                fullWidth: true,
                onChange: @changeURL,
                id: "add-bonafide"
                hintText: "Add URL demonstrating that this expert is knowledgeable",
                floatingLabelText: "Add Credential",
              }
            )
            React.createElement(Material.FlatButton, { label: "Add", onClick: @addBonaFide })
  
