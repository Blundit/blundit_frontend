{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Experts'
  
  render: ->
    div {},
      Header {}, ''
      div { className: "experts-wrapper" },
        div { className: "experts-content" },
          "Expert"
      Footer {}, ''