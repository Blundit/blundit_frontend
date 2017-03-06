{ div } = React.DOM

module.exports = React.createFactory React.createClass
  goToItem: (id) ->
    navigate("/predictions/#{id}")


  render: ->
    { prediction } = @props
    div { className: "expert__predictions-list-item" },
      div
        className: "expert__predictions-list-item__title"
        onClick: @goToItem.bind(@, prediction.alias)
        prediction.title