{ div } = React.DOM

ExpertSubstantiations = require("components/ExpertSubstantiations")

module.exports = React.createFactory React.createClass
  displayName: "PredictioNExpertCard"

  getInitialState: ->
    showSubstantiation: false


  goToItem: (id) ->
    navigate("/experts/#{id}")

  
  showSubstantiation: ->
    { expert } = @props
    return "X" if @state.showSubstantiation == true
    
    if expert.evidence_of_beliefs == 0
      return "Unsubstantiated"
    else
      return "#{expert.evidence_of_beliefs} substantiations"


  toggleSubstantiation: ->
    @setState showSubstantiation: !@state.showSubstantiation


  render: ->
    { expert, prediction } = @props
    div { className: "prediction__experts-list-item" },
      div
        className: "prediction__experts-list-item__title"
        onClick: @goToItem.bind(@, expert.alias)
        expert.name
      div
        className: "prediction__experts-list-item__substantiations"
        onClick: @toggleSubstantiation
        @showSubstantiation()
      if @state.showSubstantiation == true
        ExpertSubstantiations
          expert: expert
          id: prediction.id
          type: "prediction"