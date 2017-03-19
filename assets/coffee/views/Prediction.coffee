{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
PredictionExpertCard = require("components/PredictionExpertCard")
Comment = require("components/Comments")

module.exports = React.createFactory React.createClass
  displayName: 'Prediction'

  getInitialState: ->
    prediction: null
    experts: []
    loadError: null


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

  
  render: ->
    { prediction, experts } = @state
    div {},
      Header {}, ''
      div { className: "predictions-wrapper" },
        div { className: "predictions-content" },
          if prediction?
            div { className: "prediction" },
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
              Comments
                type: "prediction"
                id: prediction.id
                num: prediction.comments_count
          else
            div {},
              @state.loadError
      Footer {}, ''