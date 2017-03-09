{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Register Successful'
  
  render: ->
    div {},
      Header {}, ''
      div { className: "landing-wrapper" },
        div { className: "landing-content" },
          "You've successfully registered! You'll get a confirmation email shortly, which will allow you to log in and start Blunditing."
      Footer {}, ''