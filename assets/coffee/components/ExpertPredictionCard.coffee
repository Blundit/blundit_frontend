{ div } = React.DOM

ExpertSubstantiations = require("components/ExpertSubstantiations")

module.exports = React.createFactory React.createClass
  displayName: "ExpertPredictionCard"

  getInitialState: ->
    showSubstantiation: false


  goToItem: (id) ->
    navigate("/predictions/#{id}")


  showSubstantiation: ->
    { prediction } = @props
    return "X" if @state.showSubstantiation == true
    
    if prediction.evidence_of_beliefs == 0
      return "Unsubstantiated"
    else
      return "#{prediction.evidence_of_beliefs} evidences"


  toggleSubstantiation: ->
    @setState showSubstantiation: !@state.showSubstantiation


  render: ->
    { prediction } = @props
    div { className: "expert__predictions-list-item" },
      div
        className: "expert__predictions-list-item__title"
        onClick: @goToItem.bind(@, prediction.alias)
        prediction.title
      div
        className: "expert__predictions-list-item__substatiations"
        onClick: @toggleSubstantiation
        @showSubstantiation()
      if @state.showSubstantiation == true
        ExpertSubstantiations
          expert: @props.expert
          id: prediction.id
          type: "prediction"