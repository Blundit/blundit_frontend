Card = Material.Card
CardHeader = Material.CardHeader
CardText = Material.CardText
CardActions = Material.CardActions
FlatButton = Material.FlatButton

{ div, img } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'PredictionCard'

  goToPrediction: ->
    { prediction } = @props
    navigate("/predictions/#{prediction.alias}")


  render: ->
    { prediction } = @props
    div { className: "prediction-card" },
      React.createElement(Card, {},
        React.createElement(CardHeader,
          {
            title: prediction.title
            subtitle: prediction.description
          },
        )
        React.createElement(CardActions, {},
          React.createElement(FlatButton, { label: "View", onClick: @goToPrediction })
        )
      )
