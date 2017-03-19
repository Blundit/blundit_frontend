{ div } = React.DOM

module.exports = React.createFactory React.createClass
  goToItem: (id) ->
    navigate("/claims/#{id}")

  
  showSubstantiation: ->
    { claim } = @props
    if claim.evidence_of_beliefs == 0
      return "Unsubstantiated"
    else
      return "#{claim.evidence_of_beliefs} evidences"


  render: ->
    { claim } = @props
    div { className: "expert__claims-list-item" },
      div
        className: "expert__claims-list-item__title"
        onClick: @goToItem.bind(@, claim.alias)
        "#{claim.title} (#{@showSubstantiation()})"