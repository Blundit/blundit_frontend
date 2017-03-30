{ div, a } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: "ClaimEvidences"

  getInitialState: ->
    evidenceURL: ''

  
  addItem: ->
    if @state.evidenceUrl == ''
      @setState error: 'URL Required'
      return false

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
    @props.refresh()


  addError: (error) ->
    @setState error: "Error adding Evidence"
    

  handleChange: (event, index, value) ->
    @setState item: value

  
  cancelAddItem: ->
    @setState item: null
    @setState showItems: false

  
  changeEvidence: (event) ->
    @setState evidenceURL: event.target.value


  render: ->
    div { className: "claim__evidences" },
      @props.evidences.map (evidence, index) ->
        div
          className: "claim__evidence"
          key: "claim-evidence-#{index}"
          a
            target: "_blank"
            href: evidence.url
            evidence.title
        
      div {},
        React.createElement(Material.TextField,
          {
            value: @state.evidenceURL,
            hintText: "Add Evidence that supports this claim",
            fullWidth: true,
            onChange: @changeEvidence
          }
        )
        React.createElement(Material.FlatButton, { label: "Add", onClick: @addItem })
        if @state.error?
          div {},
            @state.error