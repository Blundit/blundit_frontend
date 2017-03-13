Card = Material.Card
CardHeader = Material.CardHeader
CardMedia = Material.CardMedia
CardText = Material.CardText
CardTitle = Material.CardTitle
CardActions = Material.CardActions
FlatButton = Material.FlatButton

{ div, img } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'ExpertCard'

  avatar: ->
    { expert } = @props
    if expert.avatar_file_name?
      return expert.avatar_file_name
    return "/images/avatars/placeholder.png"


  goToExpert: ->
    { expert } = @props
    navigate("/experts/#{expert.alias}")


  render: ->
    { expert } = @props
    div { className: "expert-card" },
      React.createElement(Card, {},
        React.createElement(CardMedia,
          {
            overlay: React.createElement(CardTitle, { title: expert.name, subtitle: "Extra Details" })
          },
          img {src: @avatar() }
        )
        React.createElement(CardText, {},
          "About this expert: #{expert.description}"
        )
        React.createElement(CardActions, {},
          React.createElement(FlatButton, { label: "View", onClick: @goToExpert })
        )
      )