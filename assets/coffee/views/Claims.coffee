{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Claims'
  
  render: ->
    div {},
      Header {}, ''
      "Claims"
      Footer {}, ''