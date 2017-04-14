{ div, img, br, span, a } = React.DOM

LinksMixin = require("mixins/LinksMixin")
AvatarMixin = require("mixins/AvatarMixin")

module.exports = React.createFactory React.createClass
  displayName: 'ExpertTExtCard'
  mixins: [LinksMixin, AvatarMixin]

  showAccuracy: ->
    accuracy = @props.expert.accuracy

    return Math.floor(accuracy*100) + "%"


  getCommentsCount: (count) ->
    if count < 1000
      return count
    else if count >= 1000 and count < 1000000
      return Math.floor((count/1000)*10)/10 + "K"
    else if count >= 1000000 and count < 1000000000
      return Math.floor((count/1000000)*10)/10 + "M"
    else if count >= 1000000000 and count < 1000000000000
      return Math.floor((count/1000000000)*10)/10 + "B"
    else
      return "Inf"
  
  
  render: ->
    { expert } = @props
    div { className: "expert-text-card" },
      div
        className: "expert-text-card__avatar"
        style:
          backgroundImage: "url(#{@getExpertAvatar(expert)})"
      div
        className: "expert-text-card__name"
        onClick: @goToExpert.bind(@, expert.alias)
        expert.name
      div { className: "expert-text-card__comments" },
        @getCommentsCount(expert.comments_count)
        span { className: "fa fa-comment" }, ''