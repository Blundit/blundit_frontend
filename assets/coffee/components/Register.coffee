{ div, a } = React.DOM

LinksMixin = require("mixins/LinksMixin")

module.exports = React.createFactory React.createClass
  displayName: 'Register'
  mixins: [LinksMixin]

  getInitialState: ->
    email: ''
    password: ''
    password_confirmation: ''
    errors: []
    registerError: null
    registerLoading: false


  handleEmailChange: (event) ->
    @setState email: event.target.value

  
  handlePasswordChange: (event) ->
    @setState password: event.target.value

  
  handlePasswordConfirmationChange: (event) ->
    @setState password_confirmation: event.target.value


  validateInputs: ->
    @errors = []
    if @state.email.length < 6 or @state.email.indexOf("@", 0) == -1 or @state.email.indexOf(".", 0) == -1
      @errors.push { id: "email", text: "Valid Email Required" }

    if @state.password == ''
      @errors.push { id: "password", text: "Password Required" }

    if @state.password_confirmation == ''
      @errors.push { id: "password_confirmation", text: "Password Required" }

    if @state.password != '' and @state.password_confirmation != '' and @state.password != @state.password_confirmation
      @errors.push { id: "password", text: "Password and Password Confirmation must match." }
      @errors.push { id: "password_confirmation", text: "Password and Password Confirmation must match." }
    
    @setState errors: @errors

    return true if @errors.length == 0
    return false


  processRegister: ->
    if @validateInputs()
      @setState registerError: false
      @setState errors: []
      @setState registerLoading: true

      params = {
        path: "register"
        data:
          email: @state.email
          password: @state.password
          password_confirmation: @state.password_confirmation
        success: @registerSuccess
        error: @registerError
      }

      API.call(params)


  registerSuccess: (data, request) ->
    @setState registerLoading: false
    @props.changeView('registered')


  registerError: (error) ->
    @setState registerLoading: false
    if error.responseJSON? and error.responseJSON.errors?
      @setState registerError: error.responseJSON.errors[0]


  getErrorText: (key) ->
    for error in @state.errors
      if error.id == key
        return error.text
    
    return null

  
  showLogin: ->
    @props.changeView('login')

  
  render: ->
    div {},
      "Register"

      div {},
        div {},
          React.createElement(Material.TextField, { id: "register-email", floatingLabelText: "Email", value: @state.email, onChange: @handleEmailChange, errorText: @getErrorText("email") })
        div {},
          React.createElement(Material.TextField, {id: "register-password", floatingLabelText: "Password", type: "password", value: @state.password, onChange: @handlePasswordChange, errorText: @getErrorText("password") })
        div {},
          React.createElement(Material.TextField, {id: "register-password-confirmation", floatingLabelText: "Confirm", type: "password", value: @state.password_confirmation, onChange: @handlePasswordConfirmationChange, errorText: @getErrorText("password_confirmation") })
        div {},
          if @state.registerLoading == true
            @style = {
              display: 'inline-block'
              position: 'relative'
              boxShadow: 'none'
            }
            React.createElement(Material.RefreshIndicator, { style: @style, size: 50, left: 0, top: 0, status:"loading" })

          else
            React.createElement(Material.RaisedButton, {label: "Register", primary: true, onClick: @processRegister })
        if @state.registerError?
          div {},
            @state.registerError

      div {},
        a
          onClick: @showLogin
          'Click here to login'