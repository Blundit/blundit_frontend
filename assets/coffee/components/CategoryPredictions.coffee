{ div } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: "Category Predictions - Latest"

  render: ->
    div { className: "categories__predictions" },
      div { className: "categories__predictions-title" },
        "Predictions"
      if @props.predictions.length > 0
        @props.predictions.map (prediction, index) =>
          div { className: "categories__predictions__prediction" },
            div { className: "categories__predictions__prediction-title" },
              prediction.title
      else
        div { className: "categories__predictions--empty" },
          "There are no predictions in this category."