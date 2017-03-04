{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: '404'
  
  render: ->
    div {},
      Header {}, ''
      "404"
      Footer {}, ''