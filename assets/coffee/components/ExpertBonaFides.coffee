{ div, a } = React.DOM

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

    div { className: "expert__bona-fides" },
      if bona_fides.length == 0
        "This expert currently has no bona fides."
      else
        bona_fides.map (bona_fide, index) ->
          div { className: "expert__bona-fide" },
            a
              href: bona_fide.url
              target: "_blank"
              bona_fide.title
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
              }
            )
            React.createElement(Material.FlatButton, { label: "Add", onClick: @addBonaFide })
  
