{ div } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: "Category Claims - Latest"

  render: ->
    div { className: "categories__claims" },
      div { className: "categories__claims-title" },
        "Claims"
      if @props.claims.length > 0
        @props.claims.map (claim, index) =>
          div { className: "categories__claims__claim" },
            div { className: "categories__claims__claim-title" },
              claim.title
      else
        div { className: "categories__claims--empty" },
          "There are no claims in this category."