{ div, a } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: "PredictionEvidences"

  getInitialState: ->
    evidenceURL: ''

  
  addItem: ->
    if @state.evidenceUrl == ''
      @setState error: 'URL Required'
      return false

    @setState error: null
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
    @setState evidenceUrl: ''
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
    div { className: "prediction__evidences" },
      @props.evidences.map (evidence, index) ->
        div
          className: "prediction__evidence"
          key: "prediction-evidence-#{index}"
          a
            target: "_blank"
            href: evidence.url
            evidence.title
        
      div {},
        React.createElement(Material.TextField,
          {
            value: @state.evidenceURL,
            hintText: "Add Evidence that supports this prediction",
            fullWidth: true,
            onChange: @changeEvidence
          }
        )
        React.createElement(Material.FlatButton, { label: "Add", onClick: @addItem })
        if @state.error?
          div {},
            @state.error