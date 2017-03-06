{ div } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: "Category Predictions - Latest"

  goToPredictions: (id) ->
    navigate("/predictions/#{id}")


  render: ->
    div { className: "categories__predictions" },
      div { className: "categories__predictions-title" },
        "Predictions:"
      if @props.predictions.length > 0
        @props.predictions.map (prediction, index) =>
          div
            className: "categories__predictions__prediction"
            key: "category-predictions-#{index}"
            div
              className: "categories__predictions__prediction-title"
              onClick: @goToPredictions.bind(@, prediction.id)
              prediction.title
      else
        div { className: "categories__predictions--empty" },
          "There are no predictions in this category."