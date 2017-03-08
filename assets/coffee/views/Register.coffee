{ div, a } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Register'

  goToLogin: ->
    navigate('/login')

  
  render: ->
    div {},
      Header {}, ''
      div { className: "user-wrapper" },
        div { className: "user-content" },
          "Register"
          div {},
            a
              onClick: @goToLogin
              'Click here to login'
      Footer {}, ''