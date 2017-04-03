{ div } = React.DOM

LinksMixin = require("mixins/LinksMixin")

module.exports = React.createFactory React.createClass
  displayName: "Category Experts - Latest"
  mixins: [LinksMixin]

  render: ->
    div { className: "categories__experts" },
      div { className: "categories__experts-title" },
        "Experts:"
      if @props.experts.length > 0
        @props.experts.map (expert, index) =>
          div
            className: "categories__experts__expert"
            key: "category-expert-#{index}"
            div
              className: "categories__experts__expert-name"
              onClick: @goToExpert.bind(@, expert.id)
              expert.name
      else
        div { className: "categories__experts--empty" },
          "There are no experts in this category."