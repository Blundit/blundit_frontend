{ div, a } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: "ExpertSubstantiations"
  getInitialState: ->
    data: null
    url: ''
    addSubstantiationError: null


  componentDidMount: ->
    @fetchSubstantiationData()


  fetchSubstantiationData: ->
    params = {
      path: "get_substantiations"
      path_variables:
        expert_id: @props.expert.id
      data:
        type: @props.type
        id: @props.id

      success: @substantiationsSuccess
      error: @substantiationsError
    }

    API.call(params)


  substantiationsSuccess: (data) ->
    @setState data: data

    # TODO: Add bit here to pass updated data to parent, to
    # reflect data without having to reload the whole thing.
    # Need to be pretty generic about it.
  

  addSubstantiation: ->
    if @state.url == ''
      @setState addSubstantiationError: "Url required"
      return

    params = {
      path: "add_substantiation"
      path_variables:
        expert_id: @props.expert.id
      data:
        type: @props.type
        id: @props.id
        url: @state.url

      success: @addSubstantiationsSuccess
      error: @addSubstantiationsError
    }

    API.call(params)

  
  addSubstantiationsSuccess: (data) ->
    @setState url: ''
    @fetchSubstantiationData()


  addSubstantiationsError: (error) ->
    if error.responseJSON? and error.responseJSON.errors?
      @setState addSubstantiationError: error.responseJSON.errors[0]
    else
      @setState addSubstantiationError: "There was an error."


  changeURL: (event) ->
    @setState url: event.target.value


  render: ->
    @refreshStyle = {
      display: 'inline-block'
      position: 'relative'
      boxShadow: 'none'
    }
    { expert, type } = @props

    if @state.data == null
      React.createElement(Material.RefreshIndicator, { style: @refreshStyle, size: 50, left: 0, top: 0, status:"loading" })
    else
      div { className: "substantiation-list" },
        if @state.data.length > 0
          @state.data.map (substantiation, index) =>
            div
              className: "substantiation-list__item"
              key: "substantiation-list-#{@props.id}-#{index}"
              a
                className: "substantiation-list__item-link"
                href: substantiation.url
                target: "_blank"
                substantiation.title
              div { className: "substantiation-list__item-description" },
                substantiation.description
        else
          "There are currently no links substantianting #{expert.name}'s belief in this #{type}."

        if UserStore.loggedIn()
          div { },
            "Add Substantiation:"
            React.createElement(Material.TextField,
              {
                value: @state.url,
                fullWidth: true,
                onChange: @changeURL,
                id: "add-substantiation"
              }
            )
            React.createElement(Material.FlatButton, { label: "Add", onClick: @addSubstantiation })
            
            if @state.addSubstantiationError?
              div {},
                @state.addSubstantiationError
      