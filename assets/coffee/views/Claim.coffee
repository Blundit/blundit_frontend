{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ClaimExpertCard = require("components/ClaimExpertCard")
Comments = require("components/Comments")

SessionMixin = require("mixins/SessionMixin")

module.exports = React.createFactory React.createClass
  mixins: [SessionMixin]
  displayName: 'Landing'

  getInitialState: ->
    claim: null
    experts: []
    loadError: null
    showCreated: @doShowCreated()


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


  successCardStyle: ->
    return {
      backgroundColor: "#237a0b"
      color: "#ffffff"
      margin: 4
    }


  removeAlert: ->
    @setState showCreated: false

  
  doShowCreated: ->
    if @getParameterByName("created") == 1 or @getParameterByName("created") == "1"
      return true
    else
      return false

  
  showNewClaimText: ->
    div { className: "claim__created" },
      if @state.showCreated == true
        React.createElement(Material.Chip, {
          style: @successCardStyle(),
          onRequestDelete: @removeAlert
        },
          "Success! You've added a new claim to the system. Now you can add more information to it!"
        )
  
  render: ->
    { claim, experts } = @state
    div {},
      Header {}, ''
      div { className: "claims-wrapper" },
        div { className: "claims-content" },
          if claim?
            div { className: "claim" },
              @showNewClaimText()
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