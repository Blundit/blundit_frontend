{ div, img, span } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ClaimExpertCard = require("components/ClaimExpertCard")
Comments = require("components/Comments")
Votes = require("components/Votes")
AddToClaim = require("components/AddToClaim")
ClaimEvidences = require("components/ClaimEvidences")
BookmarkIndicator = require("components/BookmarkIndicator")

SessionMixin = require("mixins/SessionMixin")
LinksMixin = require("mixins/LinksMixin")

module.exports = React.createFactory React.createClass
  mixins: [SessionMixin, LinksMixin]
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

  
  updateBookmark: (data) ->
    @claim = @state.claim
    @claim.bookmark = data
    @setState claim: @claim


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

  
  claimDescription: ->
    { claim } = @state
    if claim.description? and claim.description > ''
      return claim.description
    else
      return span { className: "not-found" }, "This claim has no description."

    
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
              div { className: "default__card" },
                div { className: "text__title claim__title" },
                  claim.title
                div
                  className: "claim__image"
                  style:
                    backgroundImage: "url(#{claim.pic})"
                div { className: "claim__meta" },
                  div { className: "claim__meta-status" },
                    "This claim is #{@showStatus()}"
                  div { className: "claim__meta-description" },
                    @claimDescription()
                  div { className: "not-found" },
                    "TODO: Add other fields here."
                if UserStore.loggedIn()
                  div { className: "claim__bookmark" },
                    BookmarkIndicator
                      bookmark: @state.claim.bookmark
                      type: "claim"
                      id: @state.claim.id
                      updateBookmark: @updateBookmark
              div { className: "default__card claim__categories" },
                div { className: "text__title" },
                  "Categories"
                div { className: "text__normal" },
                  "These are the categories this claim is connected to:"
                if claim.categories.length == 0
                  div { className: "not-found" },
                    "No categories yet."
                else
                  div { className: "default__card" },
                    claim.categories.map (category, index) =>
                      React.createElement( Material.Chip,
                        { onTouchTap: @goToCategory.bind(@, category.id), key: "claim-category-chip-#{index}", style: @categoryMaterialStyle() },
                        category.name
                      )
              div { className: "default__card claim__accuracy" },
                div { className: "text__title" },
                  "Accuracy"
                "This claim is marked: #{@showAccuracy(claim.vote_value)}"
              Votes
                type: "claim"
                item: claim
                vote: @vote
                submitting: @state.voteSubmitting
                submitted: @state.voteSubmitted
              div { className: "default__card claim__experts" },
                div { className: "text__title claim__experts-name" },
                  "Experts"
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
              Comments
                type: "claim"
                id: claim.id
                item: claim
                num: claim.comments_count
          else
            div {},
              @state.loadError
      Footer {}, ''