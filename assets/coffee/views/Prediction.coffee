{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Prediction'
  
  render: ->
    div {},
      Header {}, ''
      "Prediction"
      Footer {}, ''