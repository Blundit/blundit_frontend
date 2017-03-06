{ div } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: "Category Claims - Latest"

  goToClaim: (id) ->
    navigate("/claims/#{id}")


  render: ->
    div { className: "categories__claims" },
      div { className: "categories__claims-title" },
        "Claims:"
      if @props.claims.length > 0
        @props.claims.map (claim, index) =>
          div
            className: "categories__claims__claim"
            key: "category-claim-#{index}"
            div
              className: "categories__claims__claim-title"
              onClick: @goToClaim.bind(@, claim.id)
              claim.title
      else
        div { className: "categories__claims--empty" },
          "There are no claims in this category."