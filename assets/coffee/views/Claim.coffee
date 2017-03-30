{ div, img } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ClaimExpertCard = require("components/ClaimExpertCard")
Comments = require("components/Comments")
Votes = require("components/Votes")
AddToClaim = require("components/AddToClaim")
ClaimEvidences = require("components/ClaimEvidences")

SessionMixin = require("mixins/SessionMixin")

module.exports = React.createFactory React.createClass
  mixins: [SessionMixin]
  displayName: 'Claim'

  getInitialState: ->
    claim: null
    experts: []
    loadError: null
    showCreated: @doShowCreated()
    voteSubmitted: null
    voteSubmitting: false


  componentDidMount: ->
    @fetchClaim()

  
  fetchClaim: ->
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


  vote: (v) ->
    { claim } = @state
    @setState voteSubmitting: true

    params = {
      path: "vote_for_claim"
      path_variables:
        claim_id: claim.id
      data:
        value: v
      success: @voteSuccess
      error: @voteError
    }

    API.call(params)

  
  voteSuccess: (data) ->
    @setState voteSubmitting: false
    @setState voteSubmitted: true

  
  voteError: (error) ->
    @setState voteSubmitting: false
    @setState voteSubmitted: false

  
  goToCategory: (id) ->
    navigate("/categories/#{id}")


  categoryMaterialStyle: ->
    { margin: 4 }


  showAccuracy: (val) ->
    if val == null
      return "Unknown"
    else
      if val >= 0.5
        return "Correct"
      else
        return "Incorrect"

    
  showStatus: ->
    { claim } = @state

    if claim?
      if claim.open == false
        return "Not Yet Open"
      else if claim.open == true
        return "Open"
      else if claim.status == 1
        return "Closed"

    else
      return "Unknown"


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
              div { className: "claim__image" },
                img { src: claim.pic }
              div { className: "claim__meta" },
                div { className: "claim__meta-status" },
                  "This claim is #{@showStatus()}"
              div { className: "claim__description" },
                claim.description
              div { className: "claim__categories" },
                "These are the categories this claim is connected to:"
                if claim.categories.length == 0
                  div {},
                    "No categories yet."
                else
                  div {},
                    claim.categories.map (category, index) =>
                      React.createElement( Material.Chip,
                        { onTouchTap: @goToCategory.bind(@, category.id), key: "claim-category-chip-#{index}", style: @categoryMaterialStyle() },
                        category.name
                      )
              div { className: "claim__accuracy" },
                "This claim is marked: #{@showAccuracy(claim.vote_value)}"
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
                if UserStore.loggedIn()
                  AddToClaim
                    claim: claim
                    type: "claim"
                    items: experts
                    refresh: @fetchClaim
              ClaimEvidences
                evidences: claim.evidences
                claim: claim
                refresh: @fetchClaim
              Votes
                type: "claim"
                item: claim
                vote: @vote
                submitting: @state.voteSubmitting
                submitted: @state.voteSubmitted
              Comments
                type: "claim"
                id: claim.id
                num: claim.comments_count
          else
            div {},
              @state.loadError
      Footer {}, ''