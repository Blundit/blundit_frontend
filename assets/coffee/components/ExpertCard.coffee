{ div, img, br, span, a } = React.DOM

LinksMixin = require("mixins/LinksMixin")
AvatarMixin = require("mixins/AvatarMixin")

module.exports = React.createFactory React.createClass
  displayName: 'ExpertCard'
  mixins: [LinksMixin, AvatarMixin]

  getExpertDescription: ->
    if @props.expert.description?
      return @props.expert.description

    return ''

  getExpertOccupation: ->
    if @props.expert.occupation?
      return @props.expert.occupation
    
    return ''

  
  showAccuracy: ->
    accuracy = @props.expert.accuracy

    return Math.floor(accuracy*100) + "%"


  getCommentInfo: ->
    { expert } = @props
    return "#{expert.comments_count} comments"


  expertCardStyle: ->
    return {
      height: "100%"
      position: "relative"
    }

  
  viewButtonStyle: ->
    return {
      width: "100%"
      textAlign: "center"
    }


  render: ->
    { expert } = @props
    div { className: "expert-card" },
      React.createElement(Material.Card, { style: @expertCardStyle() },
        React.createElement(Material.CardMedia,
          {
            overlay: React.createElement(Material.CardTitle, { title: expert.name, subtitle: @getExpertOccupation() }),
            onClick: @goToExpert.bind(@, expert.alias),
            className: "expert-card__media"
          },
          div
            className: "expert-card__avatar"
            style:
              backgroundImage: "url(#{@getExpertAvatar(expert)})"
        )
       
        if expert.categories.length > 0
          div { className: "expert-card-category" },
            span
              onClick: @goToCategory.bind(@, expert.categories[0].id)
              expert.categories[0].name
        div { className: "expert-card-meta" },
          div { className: "expert-card-meta__left" },
            "Accuracy: #{@showAccuracy()}"
          div { className: "expert-card-meta__right" },
            span { className: "expert-card-meta__predictions" },
              expert.number_of_predictions + " P"
            span { className: "expert-card-meta__claims" },
              expert.number_of_claims + " C"

        div { className: "expert-card-comments" },
          @getCommentInfo()
        
        if (expert.most_recent_claim? and expert.most_recent_claim.length > 0) or (expert.most_recent_prediction? and expert.most_recent_prediction.length > 0)
          div { className: "expert-card-links" },
            if expert.most_recent_claim.length > 0
              a
                onClick: @goToMostRecentClaim
                expert.most_recent_claim[0].title

            if expert.most_recent_prediction.length > 0
              a
                onClick: @goToMostRecentPrediction
                expert.most_recent_prediction[0].title
      )