{ div, img, br, span, a } = React.DOM

LinksMixin = require("mixins/LinksMixin")

module.exports = React.createFactory React.createClass
  displayName: 'ExpertCard'
  mixins: [LinksMixin]

  avatar: ->
    { expert } = @props
    if expert.avatar?
      return expert.avatar
    return "/images/avatars/placeholder.png"



  getExpertDescription: ->
    if @props.expert.description?
      return @props.expert.description

    return ''

  
  showAccuracy: ->
    accuracy = @props.expert.accuracy

    return Math.floor(accuracy*100) + "%"


  getCommentInfo: ->
    { expert } = @props
    return "#{expert.comments_count} comments"


  render: ->
    { expert } = @props
    div { className: "expert-card" },
      React.createElement(Material.Card, {},
        React.createElement(Material.CardMedia,
          {
            overlay: React.createElement(Material.CardTitle, { title: expert.name, subtitle: @getExpertDescription() })
          },
          img {src: @avatar() }
        )
       
        React.createElement(Material.CardText, {}, @getAccuracy)

        div { className: "expert-card-meta" },
          div { className: "expert-card-meta__left" },
            @showAccuracy()
          div { className: "expert-card-meta__right" },
            span { className: "expert-card-meta__predictions" },
              expert.number_of_predictions
            span { className: "expert-card-meta__claims" },
              expert.number_of_claims

        div { className: "expert-card-comments" },
          @getCommentInfo()
        
        if expert.most_recent_claim.length > 0 or expert.most_recent_prediction > 0
          div { className: "expert-card-links"},
            if expert.most_recent_claim.length > 0
              div {},
                "Most recent Claim: "
                a
                  onClick: @goToMostRecentClaim
                  expert.most_recent_claim[0].title

            if expert.most_recent_prediction.length > 0
              div {},
                "Most recent Prediction: "
                a
                  onClick: @goToMostRecentPrediction
                  expert.most_recent_prediction[0].title
        if expert.categories.length > 0
          div { className: "expert-card-categories" },
            expert.categories.map (category, index) =>
              span
                key: "expert-card-category-#{index}"
                className: "expert-card-categories__category"
                onClick: @goToCategory.bind(@, category.id)
                category.name




        React.createElement(Material.CardActions, {},
          React.createElement(Material.FlatButton, { label: "View", onClick: @goToExpert.bind(@, expert.alias) })
        )
      )