{ div } = React.DOM

ExpertSubstantiations = require("components/ExpertSubstantiations")
LinksMixin = require("mixins/LinksMixin")

module.exports = React.createFactory React.createClass
  displayName: "ClaimExpertCard"
  mixins: [LinksMixin]

  getInitialState: ->
    showSubstantiation: false


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
    { expert, claim } = @props
    div { className: "claim__experts-list-item" },
      div
        className: "claim__experts-list-item__title"
        onClick: @goToExpert.bind(@, expert.alias)
        expert.name
      div
        className: "claim__experts-list-item__substantiations"
        onClick: @toggleSubstantiation
        @showSubstantiation()
      if @state.showSubstantiation == true
        ExpertSubstantiations
          expert: expert
          id: claim.id
          type: "claim"