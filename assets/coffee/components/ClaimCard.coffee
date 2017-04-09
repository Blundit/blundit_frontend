{ div, img, a, br, span } = React.DOM

LinksMixin = require("mixins/LinksMixin")

module.exports = React.createFactory React.createClass
  displayName: 'ClaimCard'
  mixins: [LinksMixin]

  getDescription: ->
    { claim } = @props
    if claim.description?
      return claim.description

    return ''


  getStatus: ->
    { claim } = @props
    if claim.status == 0
      return "Uknown"
    else if claim.status == 1
      if claim.vote_value >= 0.5
        return "Right"
      else
        return "Wrong"

  
  claimDate: ->
    { claim } = @props
    return claim.created_at

  
  getVoteInfo: ->
    { claim } = @props

    if !claim.votes_count?
      votes = 0
    else
      votes = claim.votes_count
    
    return "#{votes} votes"


  getCommentInfo: ->
    { claim } = @props
    return "#{claim.comments_count} comments"


  render: ->
    { claim } = @props
    div { className: "claim-card" },
      React.createElement(Material.Card, {},
        div
          className: "claim-card-title"
          onClick: @goToClaim.bind(@, claim.alias)
          claim.title
        div { className: "claim-card-text" },
          div { className: "claim-card-meta" },
            div { className: "claim-card-meta__status" },
              @getStatus()
            div { className: "claim-card-meta__votes" },
              @getVoteInfo()
            div { className: "claim-card-meta__comments" },
              @getCommentInfo()
          if claim.categories.length > 0
            div { className: "claim-card-category" },
              span
                onClick: @goToCategory.bind(@, claim.categories[0].id)
                claim.categories[0].name

          if claim.recent_experts.length > 0
            div { className: "claim-card-experts" },
              claim.recent_experts.map (expert, index) =>
                div
                  key: "claim-card-expert-#{index}"
                  className: "claim-card-experts__expert"
                  onClick: @goToExpert.bind(@, expert.alias)
                  div
                    className: "claim-card-experts__expert-avatar"
                    style:
                      backgroundImage: "url(#{expert.avatar})"
                  div { className: "claim-card-experts__expert-name" },
                    expert.name
          

        React.createElement(Material.CardActions, {},
          if claim.status == 0 and UserStore.loggedIn()
            # also add check here to see if user has already voted
            # and add vote buttons
            div
              className: "claim-card-vote"
              onClick: @goToClaim.bind(@, claim.alias)
              "VOTE"
          else if claim.status == 0 and !UserStore.loggedIn()
            div { className: "claim-card-vote" },
              "Log in to Vote"
        )
      )
