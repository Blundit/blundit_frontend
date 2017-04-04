{ div, span } = React.DOM

Login = require("components/Login")
Register = require("components/Register")
ForgotPassword = require("components/ForgotPassword")
RegistrationSuccessful = require("components/RegistrationSuccessful")

module.exports = React.createFactory React.createClass
  getInitialState: ->
    view: "login"


  changeView: (view) ->
    @setState view: view

  
  render: ->
    div { className: "modal" },
      div { className: "modal__bg" }, ''
      div { className: "modal__login"},
        # TODO: Import Gameface modal hanmdling
        div { className: "modal__login-header" },
          div { className: "modal__login-title" },
            @state.view
          div { className: "modal__login-header-close" },
            span
              className: "fa fa-close"
              onClick: @props.hideLogin
              ''
        div { className: "modal__login-body" },
          if @state.view == "login"
            Login
              changeView: @changeView
              hideLogin: @props.hideLogin
          else if @state.view == "register"
            Register
              changeView: @changeView
              hideLogin: @props.hideLogin
          else if @state.view == "forgot"
            ForgotPassword
              changeView: @changeView
              hideLogin: @props.hideLogin
          else if @state.view == "registered"
            RegistrationSuccessful
              changeView: @changeView
              hideLogin: @props.hideLogin

      
      
