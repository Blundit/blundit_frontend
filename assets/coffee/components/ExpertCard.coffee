Card = Material.Card
CardHeader = Material.CardHeader
CardMedia = Material.CardMedia
CardText = Material.CardText
CardTitle = Material.CardTitle
CardActions = Material.CardActions
FlatButton = Material.FlatButton


{ div, img } = React.DOM

module.exports = React.createFactory React.createClass
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
    # const CardExampleExpandable = () => (
#   <Card>
#     <CardHeader
#       title="Without Avatar"
#       subtitle="Subtitle"
#       actAsExpander={true}
#       showExpandableButton={true}
#     />
#     <CardActions>
#       <FlatButton label="Action1" />
#       <FlatButton label="Action2" />
#     </CardActions>
#     <CardText expandable={true}>
#       Lorem ipsum dolor sit amet, consectetur adipiscing elit.
#       Donec mattis pretium massa. Aliquam erat volutpat. Nulla facilisi.
#       Donec vulputate interdum sollicitudin. Nunc lacinia auctor quam sed pellentesque.
#       Aliquam dui mauris, mattis quis lacus id, pellentesque lobortis odio.
#     </CardText>
#   </Card>
# );