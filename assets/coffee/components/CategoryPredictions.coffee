{ div } = React.DOM

LinksMixin = require("mixins/LinksMixin")

PredictionCard = require("components/PredictionCard")

module.exports = React.createFactory React.createClass
  displayName: "Category Predictions - Latest"
  mixins: [LinksMixin]


  render: ->
    div { className: "default__card categories__predictions" },
      div { className: "text__title" },
        "Predictions:"
      if @props.predictions.length > 0
        @props.predictions.map (prediction, index) =>
          PredictionCard
            prediction: prediction
            key: "category-predictions-#{index}"
      else
        div { className: "not-found" },
          "There are no predictions in this category."