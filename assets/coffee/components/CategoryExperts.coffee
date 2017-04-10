{ div } = React.DOM

LinksMixin = require("mixins/LinksMixin")

ExpertCard = require("components/ExpertCard")

module.exports = React.createFactory React.createClass
  displayName: "Category Experts - Latest"
  mixins: [LinksMixin]

  render: ->
    div { className: "default__card categories__experts" },
      div { className: "text__title" },
        "Experts:"
      if @props.experts.length > 0
        @props.experts.map (expert, index) =>
          ExpertCard
            expert: expert
            key: "category-expert-#{index}"
      else
        div { className: "not-found" },
          "There are no experts in this category."