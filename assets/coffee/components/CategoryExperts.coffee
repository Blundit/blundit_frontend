{ div } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: "Category Experts - Latest"

  render: ->
    div { className: "categories__experts" },
      div { className: "categories__experts-title" },
        "Experts"
      if @props.experts.length > 0
        @props.experts.map (expert, index) =>
          div { className: "categories__experts__expert" },
            div { className: "categories__experts__expert-name" },
              expert.name
      else
        div { className: "categories__experts--empty" },
          "There are no experts in this category."