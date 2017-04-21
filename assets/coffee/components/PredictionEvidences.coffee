{ div, a } = React.DOM

InlineLink = require("components/InlineLink")

module.exports = React.createFactory React.createClass
  displayName: "PredictionEvidences"

  getInitialState: ->
    evidenceURL: ''
    error: null
    submitting: false

  
  addItem: ->
    if @state.evidenceUrl == ''
      @setState error: 'URL Required'
      return false

    @setState error: null
    @setState submitting: true
    params = {
      path: "add_evidence_to_prediction"
      path_variables:
        prediction_id: @props.prediction.id
      data:
        url: @state.evidenceURL
      success: @addSuccess
      error: @addError
    }

    API.call(params)


  addSuccess: (data) ->
    @setState submitting: false
    @setState evidenceURL: ''
    @props.refresh()


  addError: (error) ->
    @setState submitting: false
    @setState error: "Error adding Evidence"
    

  handleChange: (event, index, value) ->
    @setState item: value

  
  cancelAddItem: ->
    @setState item: null
    @setState showItems: false

  
  changeEvidence: (event) ->
    @setState evidenceURL: event.target.value


  render: ->
    div { className: "default__card prediction__evidences" },
      div { className: "text__title" },
        "Evidence supporting this Prediction"
      if @props.evidences.length == 0
        div { className: "not-found" },
          "No supporting evidence has been added yet to this prediction."
      @props.evidences.map (evidence, index) ->
        InlineLink
          item: evidence
          key: "prediction-evidence-#{index}"
        
      div {},
        React.createElement(Material.TextField,
          {
            value: @state.evidenceURL,
            hintText: "Add Evidence that supports this prediction",
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