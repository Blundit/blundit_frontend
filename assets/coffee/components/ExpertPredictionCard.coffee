{ div, span } = React.DOM

ExpertSubstantiations = require("components/ExpertSubstantiations")

LinksMixin = require("mixins/LinksMixin")

module.exports = React.createFactory React.createClass
  displayName: "ExpertPredictionCard"
  mixins: [LinksMixin]

  getInitialState: ->
    showSubstantiation: false


  showSubstantiation: ->
    { prediction } = @props
    return span { className: "fa fa-close" }, '' if @state.showSubstantiation == true
    
    if prediction.evidence_of_beliefs == 0
      return "Unsubstantiated"
    else
      return "#{prediction.evidence_of_beliefs} substantiations"


  toggleSubstantiation: ->
    @setState showSubstantiation: !@state.showSubstantiation


  render: ->
    { prediction, expert } = @props
    div { className: "expert__predictions-list-item" },
      div
        className: "expert__predictions-list-item__title"
        onClick: @goToPrediction.bind(@, prediction.alias)
        prediction.title
      div
        className: "expert__predictions-list-item__substantiations"
        onClick: @toggleSubstantiation
        @showSubstantiation()
      if @state.showSubstantiation == true
        ExpertSubstantiations
          expert: expert
          id: prediction.id
          type: "prediction"