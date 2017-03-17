Card = Material.Card
CardHeader = Material.CardHeader
CardText = Material.CardText
CardActions = Material.CardActions
FlatButton = Material.FlatButton

{ div, img, a, br, span } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'PRedictionCard'

  goToExpert: (id) ->
    navigate("/experts/#{id}")


  goToPrediction: (id) ->
    navigate("/predictions/#{id}")


  getDescription: ->
    { prediction } = @props
    if prediction.description?
      return prediction.description

    return ''


  getStatus: ->
    { prediction } = @props
    if prediction.status == 0
      return "?"
    else if prediction.status == 1
      if prediction.vote_value >= 0.5
        return "Right"
      else
        return "Wrong"


  getVoteInfo: ->
    { prediction } = @props
    return "#{prediction.votes_count} votes"


  getCommentInfo: ->
    { prediction } = @props
    return "#{prediction.comments_count} comments"


  goToCategory: (id) ->
    navigate("/categories/#{id}")

  
  predictionDate: ->
    { prediction } = @props
    return prediction.created_at


  render: ->
    { prediction } = @props
    div { className: "prediction-card" },
      React.createElement(Card, {},
        React.createElement(CardHeader,
          {
            title: prediction.title
            subtitle: @getDescription()
          },
        ),
        div { className: "prediction-card-text" },
          div { className: "prediction-card-date" },
            @predictionDate()
          div { className: "prediction-card-status" },
            @getStatus()
          div { className: "prediction-card-votes" },
            @getVoteInfo()
          div { className: "prediction-card-comments" },
            @getCommentInfo()
          if prediction.categories.length > 0
            div { className: "prediction-card-categories" },
              prediction.categories.map (category, index) =>
                span
                  key: "prediction-card-category-#{index}"
                  className: "prediction-card-categories__category"
                  onClick: @goToCategory.bind(@, category.id)
                  category.name

          if prediction.recent_experts.length > 0
            div { className: "prediction-card-experts" },
              prediction.recent_experts.map (expert, index) =>
                div
                  key: "prediction-card-expert-#{index}"
                  className: "prediction-card-experts__expert"
                  onClick: @goToExpert.bind(@, expert.alias)
                  div
                    className: "prediction-card-experts__expert-avatar"
                    style:
                      backgroundImage: "url(#{expert.avatar})"
                  div { className: "prediction-card-experts__expert-name" },
                    expert.name
          

        React.createElement(CardActions, {},
          if prediction.status == 0 and UserStore.loggedIn()
            # also add check here to see if user has already voted
            # and add vote buttons
            div
              className: "prediction-card-vote"
              onClick: @goToPrediction
              "VOTE"
          else if prediction.status == 0 and !UserStore.loggedIn()
            div { className: "prediction-card-vote" },
              "Log in to Vote"


          React.createElement(FlatButton, { label: "View", onClick: @goToPrediction.bind(@, prediction.alias) })
        )
      )
