{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Predictions'

  getInitialState: ->
    predictions: null


  componentDidMount: ->
    params = {
      path: "predictions"
      success: @predictionListSuccess
      error: @predictionListError
    }
    API.call(params)


  predictionListSuccess: (data) ->
    @setState predictions: data.predictions


  predictionListError: (error) ->
    # console.log "error", error

  
  goToClaim: (id) ->
    navigate("/predictions/#{id}")
  
  
  render: ->
    div {},
      Header {}, ''
      div { className: "predictions-wrapper" },
        div { className: "predictions-content" },
          div { className: "predictions__list" },
            if @state.predictions?
              @state.predictions.map (prediction, index) =>
                div
                  className: "predictions__list__item"
                  key: "prediction-#{index}"
                  onClick: @goToClaim.bind(@, prediction.alias)
                  prediction.title

      Footer {}, ''