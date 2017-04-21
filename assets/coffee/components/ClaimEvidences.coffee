{ div, a } = React.DOM

InlineLink = require("components/InlineLink")

module.exports = React.createFactory React.createClass
  displayName: "ClaimEvidences"

  getInitialState: ->
    evidenceURL: ''
    submitting: false
    error: false

  
  addItem: ->
    if @state.evidenceUrl == ''
      @setState error: 'URL Required'
      return false
    
    @setState submitting: true
    @setState error: null
    params = {
      path: "add_evidence_to_claim"
      path_variables:
        claim_id: @props.claim.id
      data:
        url: @state.evidenceURL
      success: @addSuccess
      error: @addError
    }

    API.call(params)


  addSuccess: (data) ->
    @setState evidenceURL: ''
    @setState submitting: false
    @props.refresh()


  addError: (error) ->
    @setState error: "Error adding Evidence"
    @setState submitting: false
    

  handleChange: (event, index, value) ->
    @setState item: value

  
  cancelAddItem: ->
    @setState item: null
    @setState showItems: false

  
  changeEvidence: (event) ->
    @setState evidenceURL: event.target.value


  render: ->
    div { className: "default__card claim__evidences" },
      div { className: "text__title" },
        "Evidence Supporting this Claim"
      if @props.evidences.length == 0
        div { className: "not-found" },
          "No supporting evidence has been added yet to this claim."
      @props.evidences.map (evidence, index) ->
        InlineLink
          item: evidence
          key: "claim-evidence-#{index}"
        
      div {},
        React.createElement(Material.TextField,
          {
            value: @state.evidenceURL,
            hintText: "Add Evidence that supports this claim",
            fullWidth: true,
            onChange: @changeEvidence
          }
        )
        if @state.submitting == false
          React.createElement(Material.FlatButton, { label: "Add", onClick: @addItem })
        else
          React.createElement(Material.LinearProgress, { mode: "indeterminate" })

        if @state.error?
          div {},
            @state.error