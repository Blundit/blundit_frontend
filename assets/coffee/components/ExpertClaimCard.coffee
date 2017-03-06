{ div } = React.DOM

module.exports = React.createFactory React.createClass
  goToItem: (id) ->
    navigate("/claims/#{id}")


  render: ->
    { claim } = @props
    div { className: "expert__claims-list-item" },
      div
        className: "expert__claims-list-item__title"
        onClick: @goToItem.bind(@, claim.alias)
        claim.title