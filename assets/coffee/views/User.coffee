{ div, input, br, img } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

AvatarMixin = require("mixins/AvatarMixin")

module.exports = React.createFactory React.createClass
  mixins: [AvatarMixin]
  displayName: 'User'

  getInitialState: ->
    inputs:
      first_name:
        val: ''
      last_name:
        val: ''
      email:
        val: ''
      notification_frequency:
        val: ''
    user: null
    errors: []
    updateSubmitting: false
    updateError: null
    updateSuccess: null
    notification_frequencies: [
      { id: "none", title: "No Notifications" },
      { id: "as_they_happen", title: "As They Happen" },
      { id: "daily", title: "Daily Digests" },
      { id: "weekly", title: "Weekly Digests" },
      { id: "monthly", title: "Monthly Digests" }
    ]

  
  componentDidMount: ->
    UserStore.subscribe(@handleUserChange)


  componentWillUnMount: ->
    UserStore.unsubscribe(@handleUserChange)


  handleUserChange: ->
    @user = UserStore.get()
    @setState user: @user

    @inputs = @state.inputs
    @inputs.first_name.val = @user.first_name
    @inputs.last_name.val = @user.last_name
    @inputs.email.val = @user.email
    @inputs.notification_frequency.val = @user.notification_frequency

    @setState inputs: @inputs

  
  submitUserUpdate: ->
    if @validateInputs()
      @setState updateSubmitting: true
      @setState updateSuccess: null
      @setState updateError: null

      @formData = new FormData()
      avatar = document.getElementById('user__avatar')

      if avatar.files[0]?
        @formData.append("avatar", avatar.files[0])

      @formData.append("first_name", @state.inputs.first_name.val)
      @formData.append("last_name", @state.inputs.last_name.val)
      @formData.append("email", @state.inputs.email.val)
      @formData.append("notification_frequency", @state.inputs.notification_frequency.val)

      params = {
        path: "update_user"
        data: @formData
        success: @updateUserSuccess
        error: @updateUserError
      }

      API.call(params)


  validateInputs: ->
    @errors = []
    if @state.inputs.first_name.val == ''
      @errors.push { id: "first_name", text: "First Name required." }
    
    if @state.inputs.last_name.val == ''
      @errors.push { id: "last_name", text: "Last Name required." }

    if @state.inputs.email.val.length < 6 or @state.inputs.email.val.indexOf("@", 0) == -1 or @state.inputs.email.val.indexOf(".", 0) == -1
      @errors.push { id: "email", text: "Valid email required."}

    @setState errors: @errors

    return true if @errors.length == 0
    return false


  getErrorText: (key) ->
    for error in @state.errors
      if error.id == key
        return error.text
    
    return null


  updateUserSuccess: (data) ->
    UserStore.updateUserData(data.user)
    @setState updateSubmitting: false
    @setState updateSuccess: "User Updated!"
    
  
  updateUserError: (error) ->
    @setState updateSubmitting: false
    if error.responseJSON? and error.responseJSON.errors?
      @setState updateError: error.responseJSON.errors[0]
    else
      @setState updateError: "There was an error."

    
  handleFirstNameChange: (event) ->
    @inputs = @state.inputs
    @inputs.first_name.val = event.target.value

    @setState inputs: @inputs

  
  handleLastNameChange: (event) ->
    @inputs = @state.inputs
    @inputs.last_name.val = event.target.value

    @setState inputs: @inputs


  handleEmailChange: (event) ->
    @inputs = @state.inputs
    @inputs.email.val = event.target.value
    @setState inputs: @inputs
  

  handleChange: (event, index, value) ->
    @inputs = @state.inputs
    @inputs.notification_frequency.val = value

    @setState inputs: @inputs


  getUserAvatarPath: ->
    return "#{API.serverBase()}images/user_avatars/#{@state.user.avatar_file_name}"


  render: ->
    div {},
      Header {}, ''
      div { className: "user-wrapper" },
        div { className: "user-content" },
          div { className: "default__card" },
            div { className: "text__title" },
              "User Info"
            if @state.user == null or !@state.user.token?
              div { className: "user__not-logged-in" },
                "You must be logged in to view this content."
            else
              div { className: "user" },
                "If you want to update some basic info about yourself, here's the place. (Eventually, you'll be able to see stats and other cool stuff here.)"
                React.createElement(Material.TextField,
                {
                  id: "user-first-name",
                  hintText: "First Name",
                  floatingLabelText: "First Name",
                  fullWidth: true,
                  value: @state.inputs.first_name.val,
                  onChange: @handleFirstNameChange,
                  errorText: @getErrorText("first_name")
                })
                React.createElement(Material.TextField,
                {
                  id: "user-last-name",
                  hintText: "Last Name",
                  floatingLabelText: "Last Name",
                  fullWidth: true,
                  value: @state.inputs.last_name.val,
                  onChange: @handleLastNameChange,
                  errorText: @getErrorText("last_name")
                })
                React.createElement(Material.TextField,
                {
                  id: "user-email",
                  hintText: "Email",
                  floatingLabelText: "Email",
                  fullWidth: true,
                  value: @state.inputs.email.val,
                  onChange: @handleEmailChange,
                  errorText: @getErrorText("email")
                })
                React.createElement(Material.SelectField,
                  { floatingLabelText: "Notification Frequency", value: @state.inputs.notification_frequency.val, onChange: @handleChange },
                  @state.notification_frequencies.map (item, index) ->
                    React.createElement(Material.MenuItem, {value: item.id, primaryText: item.title, key: "user-notification-frequency-#{index}"})
                )
                br {}
                br {}
                br {}
                div {},
                  "Your Avatar:"
                  br {}
                  if @state.user.avatar_file_name?
                    img { src: @getUserAvatar(@state.user) }
                  input
                    className: "user__avatar"
                    type: "file"
                    id: "user__avatar"
                    accept: ".png,.jpeg,.jpg,.gif"
                div {},
                  if @state.updateSubmitting == true
                    @style = {
                      display: 'inline-block'
                      position: 'relative'
                      boxShadow: 'none'
                    }
                    React.createElement(Material.RefreshIndicator, { style: @style, size: 50, left: 0, top: 0, status:"loading" })
                  else
                    React.createElement(Material.RaisedButton, {label: "Update User", primary: true, onClick: @submitUserUpdate })

                if @state.updateError?
                  div {},
                    @state.updateError
                if @state.updateSuccess?
                  div {},
                    @state.updateSuccess
      Footer {}, ''