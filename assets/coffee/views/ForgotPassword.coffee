{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Forgot Password'

  goToLogin: ->
    navigate('/login')
    
  
  render: ->
    div {},
      Header {}, ''
      div { className: "user-wrapper" },
        div { className: "user-content" },
          "Forgot Password"
          div {},
            "Remembered your password? "
            a
              onClick: @goToLogin
              'Click here to login'
      Footer {}, ''