{ div } = React.DOM

ExpertSubstantiations = require("components/ExpertSubstantiations")

module.exports = React.createFactory React.createClass
  displayName: "ExpertClaimCard"

  getInitialState: ->
    showSubstantiation: false


  goToItem: (id) ->
    navigate("/claims/#{id}")

  
  showSubstantiation: ->
    { claim } = @props
    return "X" if @state.showSubstantiation == true
    
    if claim.evidence_of_beliefs == 0
      return "Unsubstantiated"
    else
      return "#{claim.evidence_of_beliefs} substantiations"


  toggleSubstantiation: ->
    @setState showSubstantiation: !@state.showSubstantiation


  render: ->
    { claim } = @props
    div { className: "expert__claims-list-item" },
      div
        className: "expert__claims-list-item__title"
        onClick: @goToItem.bind(@, claim.alias)
        claim.title
      div
        className: "expert__claims-list-item__substantiations"
        onClick: @toggleSubstantiation
        @showSubstantiation()
      if @state.showSubstantiation == true
        ExpertSubstantiations
          expert: @props.expert
          id: claim.id
          type: "claim"