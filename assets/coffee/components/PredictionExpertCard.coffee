{ div } = React.DOM

module.exports = React.createFactory React.createClass
  goToItem: (id) ->
    navigate("/experts/#{id}")


  render: ->
    { expert } = @props
    div { className: "claim__predictions-list-item" },
      div
        className: "claim__predictions-list-item__title"
        onClick: @goToItem.bind(@, expert.alias)
        expert.name