{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
PredictionExpertCard = require("components/PredictionExpertCard")
Comments = require("components/Comments")
Votes = require("components/Votes")

SessionMixin = require("mixins/SessionMixin")

module.exports = React.createFactory React.createClass
  mixins: [SessionMixin]
  displayName: 'Prediction'

  getInitialState: ->
    prediction: null
    experts: []
    loadError: null
    showCreated: @doShowCreated()
    voteSubmitted: null
    voteSubmitting: false


  componentDidMount: ->
    params = {
      path: "prediction"
      path_variables:
        prediction_id: @props.id
      success: @predictionSuccess
      error: @predictionError
    }
    API.call(params)

  
  predictionSuccess: (data) ->
    @setState prediction: data.prediction
    @setState experts: data.experts


  predictionError: (error) ->
    @setState loadError: error.responseJSON.errors


  successCardStyle: ->
    return {
      backgroundColor: "#237a0b"
      color: "#ffffff"
      margin: 4
    }

  
  removeAlert: ->
    @setState showCreated: false

  
  doShowCreated: ->
    if @getParameterByName("created") == 1 or @getParameterByName("created") == "1"
      return true
    else
      return false

  
  showNewPredictionText: ->
    div { className: "prediction__created" },
      if @state.showCreated == true
        React.createElement(Material.Chip, {
          style: @successCardStyle(),
          onRequestDelete: @removeAlert
        },
          "Success! You've added a new prediction to the system. Now you can add more information to it!"
        )


  vote: (v) ->
    { prediction } = @state
    @setState voteSubmitting: true

    params = {
      path: "vote_for_prediction"
      path_variables:
        prediction_id: prediction.id
      data:
        value: v
      success: @voteSuccess
      error: @voteError
    }

    API.call(params)

  
  voteSuccess: (data) ->
    @setState voteSubmitting: false
    @setState voteSubmitted: true

  
  voteError: (error) ->
    @setState voteSubmitting: false
    @setState voteSubmitted: false

  
  render: ->
    { prediction, experts } = @state
    div {},
      Header {}, ''
      div { className: "predictions-wrapper" },
        div { className: "predictions-content" },
          if prediction?
            div { className: "prediction" },
              @showNewPredictionText()
              div { className: "prediction__title" },
                prediction.title
              div { className: "prediction__experts" },
                div { className: "prediction__experts-name" },
                  "Experts:"
                div { className: "prediction__experts-list" },
                  if experts.length > 0
                    experts.map (expert, index) ->
                      PredictionExpertCard
                        expert: expert
                        prediction: prediction
                        key: "prediction-expert-#{index}"
                  else
                    "No experts"
              Votes
                type: "prediction"
                item: prediction
                vote: @vote
                submitting: @state.voteSubmitting
                submitted: @state.voteSubmitted
              Comments
                type: "prediction"
                id: prediction.id
                num: prediction.comments_count
          else
            div {},
              @state.loadError
      Footer {}, ''