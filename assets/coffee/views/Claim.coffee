{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ClaimExpertCard = require("components/ClaimExpertCard")
Comments = require("components/Comments")

module.exports = React.createFactory React.createClass
  displayName: 'Landing'

  getInitialState: ->
    claim: null
    experts: []
    loadError: null


  componentDidMount: ->
    params = {
      path: "claim"
      path_variables:
        claim_id: @props.id
      success: @claimSuccess
      error: @claimError
    }
    API.call(params)

  
  claimSuccess: (data) ->
    @setState claim: data.claim
    @setState experts: data.experts


  claimError: (error) ->
    @setState loadError: error.responseJSON.errors

  
  render: ->
    { claim, experts } = @state
    div {},
      Header {}, ''
      div { className: "claims-wrapper" },
        div { className: "claims-content" },
          if claim?
            div { className: "claim" },
              div { className: "claim__title" },
                claim.title
              div { className: "claim__experts" },
                div { className: "claim__experts-name" },
                  "Experts:"
                div { className: "claim__experts-list" },
                  if experts.length > 0
                    experts.map (expert, index) ->
                      ClaimExpertCard
                        expert: expert
                        claim: claim
                        key: "claim-expert-#{index}"
                  else
                    "No experts"
              Comments
                type: "claim"
                id: claim.id
                num: claim.comments_count
                
          else
            div {},
              @state.loadError
      Footer {}, ''