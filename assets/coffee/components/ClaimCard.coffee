Card = Material.Card
CardHeader = Material.CardHeader
CardText = Material.CardText
CardActions = Material.CardActions
FlatButton = Material.FlatButton

{ div, img, a, br, span } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'ClaimCard'

  goToExpert: (id) ->
    navigate("/experts/#{id}")


  goToClaim: (id) ->
    navigate("/claims/#{id}")


  getDescription: ->
    { claim } = @props
    if claim.description?
      return claim.description

    return ''


  getStatus: ->
    { claim } = @props
    if claim.status == 0
      return "?"
    else if claim.status == 1
      if claim.vote_value >= 0.5
        return "Right"
      else
        return "Wrong"


  goToCategory: (id) ->
    navigate("/categories/#{id}")

  
  claimDate: ->
    { claim } = @props
    return claim.created_at

  
  getVoteInfo: ->
    { claim } = @props
    return "#{claim.votes_count} votes"


  getCommentInfo: ->
    { claim } = @props
    return "#{claim.comments_count} comments"


  render: ->
    { claim } = @props
    div { className: "claim-card" },
      React.createElement(Card, {},
        React.createElement(CardHeader,
          {
            title: claim.title
            subtitle: @getDescription()
          },
        ),
        div { className: "claim-card-text" },
          div { className: "claim-card-date" },
            @claimDate()
          div { className: "claim-card-status" },
            @getStatus()
          div { className: "claim-card-votes" },
            @getVoteInfo()
          div { className: "claim-card-comments" },
            @getCommentInfo()
          if claim.categories.length > 0
            div { className: "claim-card-categories" },
              claim.categories.map (category, index) =>
                span
                  key: "claim-card-category-#{index}"
                  className: "claim-card-categories__category"
                  onClick: @goToCategory.bind(@, category.id)
                  category.name

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
          

        React.createElement(CardActions, {},
          if claim.status == 0 and UserStore.loggedIn()
            # also add check here to see if user has already voted
            # and add vote buttons
            div
              className: "claim-card-vote"
              onClick: @goToClaim
              "VOTE"
          else if claim.status == 0 and !UserStore.loggedIn()
            div { className: "claim-card-vote" },
              "Log in to Vote"


          React.createElement(FlatButton, { label: "View", onClick: @goToClaim.bind(@, claim.alias) })
        )
      )
