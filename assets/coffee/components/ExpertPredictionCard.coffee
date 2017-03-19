{ div } = React.DOM

module.exports = React.createFactory React.createClass
  goToItem: (id) ->
    navigate("/predictions/#{id}")


  showSubstantiation: ->
    { prediction } = @props
    if prediction.evidence_of_beliefs == 0
      return "Unsubstantiated"
    else
      return "#{prediction.evidence_of_beliefs} evidences"


  render: ->
    { prediction } = @props
    div { className: "expert__predictions-list-item" },
      div
        className: "expert__predictions-list-item__title"
        onClick: @goToItem.bind(@, prediction.alias)
        "#{prediction.title} (#{@showSubstantiation()})"