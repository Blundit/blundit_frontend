{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Landing'
  
  render: ->
    div {},
      Header {}, ''
      div { className: "landing-wrapper" },
        div { className: "landing-content" },
          "Landing"
      Footer {}, ''