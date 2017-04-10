{ div } = React.DOM

LinksMixin = require("mixins/LinksMixin")

ClaimCard = require("components/ClaimCard")

module.exports = React.createFactory React.createClass
  displayName: "Category Claims - Latest"
  mixins: [LinksMixin]

  render: ->
    div { className: "default__card categories__claims" },
      div { className: "text__title" },
        "Claims:"
      if @props.claims.length > 0
        @props.claims.map (claim, index) =>
          ClaimCard
            claim: claim
            key: "category-claim-#{index}"
            
      else
        div { className: "not-found" },
          "There are no claims in this category."