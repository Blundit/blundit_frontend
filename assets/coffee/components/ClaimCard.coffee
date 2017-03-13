Card = Material.Card
CardHeader = Material.CardHeader
CardText = Material.CardText
CardActions = Material.CardActions
FlatButton = Material.FlatButton

{ div, img } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'ClaimCard'

  goToExpert: ->
    { claim } = @props
    navigate("/claims/#{claim.alias}")


  render: ->
    { claim } = @props
    div { className: "claim-card" },
      React.createElement(Card, {},
        React.createElement(CardHeader,
          {
            title: claim.title
            subtitle: claim.description
          },
        )
        React.createElement(CardActions, {},
          React.createElement(FlatButton, { label: "View", onClick: @goToClaim })
        )
      )
