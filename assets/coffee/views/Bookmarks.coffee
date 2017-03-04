{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Bookmarks'
  
  render: ->
    div {},
      Header {}, ''
      "Bookmarks"
      Footer {}, ''