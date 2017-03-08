{ div, a } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

SessionMixin = require("mixins/SessionMixin")

TextField = Material.TextField
RaisedButton = Material.RaisedButton


module.exports = React.createFactory React.createClass
  mixins: [SessionMixin]

  displayName: 'Login'

  getInitialState: ->
    email: ''
    password: ''
    errors: []


  goToRegister: ->
    navigate('/register')

  
  handleEmailChange: (event) ->
    @setState email: event.target.value

  
  handlePasswordChange: (event) ->
    @setState password: event.target.value


  validateInputs: ->
    @errors = []
    if @state.email.length < 6 or @state.email.indexOf("@", 0) == -1 or @state.email.indexOf(".", 0) == -1
      @errors.push { id: "email", text: "Valid Email Required" }

    if @state.password == ''
      @errors.push { id: "password", text: "Password Required" }
    
    @setState errors: @errors

    return true if @errors.length == 0
    return false

  
  processLogin: ->
    if @validateInputs()
      params = {
        path: "login"
        data:
          email: @state.email
          password: @state.password
        success: @loginSuccess
        error: @loginError
      }

      API.call(params)


  loginSuccess: (data, request) ->
    @setUser(data.data, request)


  loginError: (error) ->
    # console.log "ERROR", error


  getErrorText: (key) ->
    for error in @state.errors
      if error.id == key
        return error.text
    
    return null

  
  render: ->
    div {},
      Header {}, ''
      div { className: "user-wrapper" },
        div { className: "user-content" },
          "Login"

          div {},
            div {},
              React.createElement(TextField, { id: "login-email", floatingLabelText: "Email", value: @state.email, onChange: @handleEmailChange, errorText: @getErrorText("email") })
            div {},
              React.createElement(TextField, {id: "login-password", floatingLabelText: "Password", type: "password", value: @state.password, onChange: @handlePasswordChange, errorText: @getErrorText("password") })
            div {},
              React.createElement(RaisedButton, {label: "Login", primary: true, onClick: @processLogin })

          div {},
            "Don't have an account? "
            a
              onClick: @goToRegister
              'Click here to register'

      Footer {}, ''