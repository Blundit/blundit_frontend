{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ClaimFields = require("components/ClaimFields")

module.exports = React.createFactory React.createClass
  displayName: "Create Claim View"

  getInitialState: ->
    claim:
      title: ''
      description: ''
      url: ''
      pic: ''
      category: ''
    errors: []
    submitClaimError: null
    submittingClaim: false


  updateField: (id, val) ->
    @claim = @state.claim
    @claim[id] = val

    @setState claim: @claim


  assembleClaimData: ->
    return @state.claim

  
  createClaim: ->
    @setState submitClaimError: null

    if @validateInputs()
      @setState submittingClaim: true

      params = {
        path: "create_claim"
        data:
          title: @state.claim.title
          description: @state.claim.description
          url: @state.claim.url
          category: @state.claim.category
        success: @createClaimSuccess
        error: @createClaimError
      }

      API.call(params)
  

  createClaimError: (error) ->
    if error.responseJSON? and error.responseJSON.errors?
      @setState submitClaimError: error.responseJSON.errors[0]
    else
      @setState submitClaimError: "There was an error."

    @setState submittingClaim: false

  
  createClaimSuccess: (data) ->
    @setState submittingClaim: false
    if data.claim?
      navigate("/claims/#{data.claim.alias}?created=1")


  validateInputs: ->
    @errors = []
    if @state.claim.title.length < 3
      @errors.push { id: "title", text: "Title must be at least 3 characters long." }

    if @state.claim.category == ''
      @errors.push { id: "category", text: "Category is required." }

    @setState errors: @errors

    return true if @errors.length == 0
    return false


  render: ->
    div {},
      Header {}, ''
      div { className: "claims-wrapper" },
        div { className: "claims-content" },
          div { className: "default__card" },
            div { className: "text__title" },
              "Create Claim"
            if UserStore.loggedIn()
              div {},
                ClaimFields
                  claim: @state.claim
                  errors: @state.errors
                  updateField: @updateField

                if @state.submittingClaim != true
                  React.createElement(Material.RaisedButton, { label: "Create", onClick: @createClaim })
                else
                  @style = {
                    display: 'inline-block'
                    position: 'relative'
                    boxShadow: 'none'
                  }
                  React.createElement(Material.RefreshIndicator, { style: @style, size: 50, left: 0, top: 0, status:"loading" })
                if @state.submitClaimError?
                  div {},
                    @state.submitClaimError

            else
              div { className: "not-found" },
                "You must be logged in to add an claim to the sytem."
      Footer {}, ''