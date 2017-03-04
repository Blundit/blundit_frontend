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
    console.log UserStore.get()

  
  render: ->
    div {},
      Header {}, ''
      div {},
        if @props.me == true
          "My page"
        else
          "User #{@props.user_id}"

      Footer {}, ''