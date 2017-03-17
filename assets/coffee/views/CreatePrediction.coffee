{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
PredictionFields = require("components/PredictionFields")

module.exports = React.createFactory React.createClass
  displayName: "Create Prediction View"

  getInitialState: ->
    prediction: {}


  render: ->
    div {},
      Header {}, ''
      div { className: "prediction-wrapper" },
        div { className: "prediction-content" },
          "Create Prediction"
          PredictionFields
            prediction: @state.prediction
      Footer {}, ''