{ div, img, a, br, span } = React.DOM

LinksMixin = require("mixins/LinksMixin")

module.exports = React.createFactory React.createClass
  displayName: 'PredictionTextCard'
  mixins: [LinksMixin]


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


  predictionDate: ->
    { prediction } = @props
    return prediction.created_at


  render: ->
    { prediction } = @props
    div { className: "prediction-text-card" },
      div
        className: "prediction-text-card__title"
        onClick: @goToPrediction.bind(@, prediction.alias)
        prediction.title
      div { className: "prediction-text-card__comments" },
        prediction.comments_count
        span { className: "fa fa-comment" }, ''
