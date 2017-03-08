{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Claims'

  getInitialState: ->
    claims: null


  componentDidMount: ->
    params = {
      path: "claims"
      success: @claimListSuccess
      error: @claimListError
    }
    API.call(params)


  claimListSuccess: (data) ->
    @setState claims: data.claims


  claimListError: (error) ->
    # console.log "error", error

  
  goToClaim: (id) ->
    navigate("/claims/#{id}")
  
  
  render: ->
    div {},
      Header {}, ''
      div { className: "claims-wrapper" },
        div { className: "claims-content" },
          div { className: "claims__list" },
            if @state.claims?
              @state.claims.map (claim, index) =>
                div
                  className: "claims__list__item"
                  key: "claim-#{index}"
                  onClick: @goToClaim.bind(@, claim.alias)
                  claim.title

      Footer {}, ''