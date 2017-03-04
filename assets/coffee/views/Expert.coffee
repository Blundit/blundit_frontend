{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Expert'
  
  render: ->
    div {},
      Header {}, ''
      "Expert"
      Footer {}, ''