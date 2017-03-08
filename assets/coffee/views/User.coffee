{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'User'

  componentDidMount: ->
    UserStore.subscribe(@handleUserChange)


  componentWillUnMount: ->
    UserStore.unsubscribe(@handleUserChange)


  handleUserChange: ->
    @setState user: UserStore.get()

  
  render: ->
    div {},
      Header {}, ''
      div { className: "user-wrapper" },
        div { className: "user-content" },
          if @props.me == true
            "My page"
          else
            "User #{@props.user_id}"

      Footer {}, ''