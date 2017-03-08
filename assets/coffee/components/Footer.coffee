{ div } = React.DOM

module.exports = React.createFactory React.createClass

  render: ->
    div { className: "footer-wrapper" },
      div { className: "footer-content" },
        "Footer"
        
