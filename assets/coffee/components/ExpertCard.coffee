Card = Material.Card
CardHeader = Material.CardHeader
CardMedia = Material.CardMedia
CardText = Material.CardText
CardTitle = Material.CardTitle
CardActions = Material.CardActions
FlatButton = Material.FlatButton

{ div, img, br, span, a } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'ExpertCard'

  avatar: ->
    { expert } = @props
    if expert.avatar?
      return expert.avatar
    return "/images/avatars/placeholder.png"


  goToExpert: ->
    { expert } = @props
    navigate("/experts/#{expert.alias}")


  getExpertDescription: ->
    if @props.expert.description?
      return @props.expert.description

    return ''

  
  goToMostRecentClaim: ->
    navigate("/claims/#{@props.expert.most_recent_claim[0].alias}")


  goToMostRecentPrediction: ->
    navigate("/predictions/#{@props.expert.most_recent_prediction[0].alias}")


  showAccuracy: ->
    accuracy = @props.expert.accuracy

    return Math.floor(accuracy*100) + "%"


  render: ->
    { expert } = @props
    div { className: "expert-card" },
      React.createElement(Card, {},
        React.createElement(CardMedia,
          {
            overlay: React.createElement(CardTitle, { title: expert.name, subtitle: @getExpertDescription() })
          },
          img {src: @avatar() }
        )
       
        React.createElement(CardText, {}, @getAccuracy)

        div { className: "expert-card-meta" },
          div { className: "expert-card-meta__left" },
            @showAccuracy()
          div { classname: "expert-card-meta__right" },
            span { className: "expert-card-meta__predictions" },
              expert.number_of_predictions
            span { className: "expert-card-meta__claims" },
              expert.number_of_claims
        
        if expert.most_recent_claim.length > 0 or expert.most_recent_prediction > 0
          div { className: "expert-card-links"},
            if expert.most_recent_claim.length > 0
              div {},
                "Most recent Claim: "
                a
                  onClick: @goToMostRecentClaim
                  expert.most_recent_claim[0].title

            if expert.most_recent_prediction.length > 0
              console.log expert.most_recent_prediction
              div {},
                "Most recent Prediction: "
                a
                  onClick: @goToMostRecentPrediction
                  expert.most_recent_prediction[0].title



        React.createElement(CardActions, {},
          React.createElement(FlatButton, { label: "View", onClick: @goToExpert })
        )
      )