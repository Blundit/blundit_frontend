{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Register'
  
  render: ->
    div {},
      Header {}, ''
      "Register"
      Footer {}, ''