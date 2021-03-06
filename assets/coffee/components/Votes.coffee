{ div, span } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'Votes'

  getInitialState: ->
    user: null

  
  handleUserChange: (data) ->
    @setState user: UserStore.get()


  componentDidMount: ->
    UserStore.subscribe(@handleUserChange)

  
  componentWillUnmount: ->
    UserStore.unsubscribe(@handleUserChange)


  getVoteValText: ->
    { item } = @props
    if item.user_vote?
      return item.user_vote.vote == 1 ? "True" : "False"
    else
      return "N/A"

  voteYes: ->
    @props.vote(1)

  
  voteNo: ->
    @props.vote(0)


  notOpenYet: ->
    { item, type } = @props

    if type != "prediction"
      return false
    else
      d1 = new Date(item.prediction_date)
      d2 = new Date()

      if d1 > d2
        return true
      else
        return false


  refreshStyle: ->
    return {
      display: 'inline-block'
      position: 'relative'
      boxShadow: 'none'
    }


  render: ->
    { type, item, submitting, submitted } = @props
    { user } = @state

    div { className: "default__card #{type}__vote" },
      div { className: "text__title" },
        "Votes"
      div { className: "text__normal #{type}__vote__meta" },
        if item.votes_count == 0
          span { className: "not-found" },
            "Be the first person to vote on this #{type}"
        else
          "This #{type} has #{item.votes_count} votes so far!"
      if item.open == "true" or item.open == true
        if user?.token?
          if submitted != true
            div { className: "#{type}__vote__info" },
              if item.user_vote?
                div { className: "#{type}__vote__info-already-voted" },
                  "You have already voted for this item. (You thought it was #{@getVoteValText()})"
              else
                div { className: "#{type}__vote__info-buttons" },
                  if submitting == true
                    React.createElement(Material.RefreshIndicator, { style: @refreshStyle, size: 50, left: 0, top: 0, status:"loading" })
                  else
                    div {},
                      React.createElement(Material.RaisedButton, {label: "I think it's true", primary: true, onClick: @voteYes })
                      React.createElement(Material.RaisedButton, {label: "I think it's false", primary: true, onClick: @voteNo })
                      if submitted == false
                        div {},
                          "There was an error. Please try again."
          else
            div { className: "#{type}__vote__info-voted" },
              "Thank you for your vote!"
        else
          div { className: "#{type}__vote--not-logged-in" },
            "You must be logged in to vote on this #{type}"
        
      else
        div { className: "#{type}__vote--closed" },
          if @notOpenYet()
            "This #{type} isn't open yet. Come back later to vote on it."
          else
            "This #{type} is closed, and can't be voted on."

      