{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Predictions'
  
  render: ->
    div {},
      Header {}, ''
      "Predictions"
      Footer {}, ''