{ div, a } = React.DOM

SessionMixin = require("mixins/SessionMixin")

module.exports = React.createFactory React.createClass
  mixins: [SessionMixin]

  displayName: 'Login'

  getInitialState: ->
    email: ''
    password: ''
    errors: []
    loginError: null
    loginLoading: false

  
  goToRegister: ->
    @props.changeView('register')


  goToForgotPassword: ->
    @props.changeView('forgot')

  
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
      @setState errors: []
      @setState loginError: false
      @setState loginLoading: true

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
    @setState loginLoading: false
    @setUser(data.data, request)
    @props.hideLogin()


  loginError: (error) ->
    @setState loginLoading: false
    if error.responseJSON? and error.responseJSON.errors?
      @setState loginError: error.responseJSON.errors[0]


  getErrorText: (key) ->
    for error in @state.errors
      if error.id == key
        return error.text
    
    return null

  
  render: ->
    div {},
      "Login"

      div {},
        div {},
          React.createElement(Material.TextField, { id: "login-email", floatingLabelText: "Email", value: @state.email, onChange: @handleEmailChange, errorText: @getErrorText("email") })
        div {},
          React.createElement(Material.TextField, {id: "login-password", floatingLabelText: "Password", type: "password", value: @state.password, onChange: @handlePasswordChange, errorText: @getErrorText("password") })
        div {},
          if @state.loginLoading == true
            @style = {
              display: 'inline-block'
              position: 'relative'
              boxShadow: 'none'
            }
            React.createElement(Material.RefreshIndicator, { style: @style, size: 50, left: 0, top: 0, status:"loading" })

          else
            React.createElement(Material.RaisedButton, {label: "Login", primary: true, onClick: @processLogin })
        if @state.loginError?
          div {},
            @state.loginError


      div {},
        a
          onClick: @goToRegister
          'Click here to register'
        a
          onClick: @goToForgotPassword
          'Forgot your password?'