{ div } = React.DOM

SessionMixin = require("mixins/SessionMixin")

module.exports = React.createFactory React.createClass
  mixins: [SessionMixin]

  getInitialState: ->
    user: null

  
  componentDidMount: ->
    UserStore.subscribe(@handleUserChange)


  componentWillUnmount: ->
    UserStore.unsubscribe(@handleUserChange)


  handleUserChange: (data) ->
    @setState user: UserStore.get()


  logout: ->
    UserStore.logout()
    @setUser {}

  
  render: ->
    div { className: "footer-wrapper" },
      div { className: "footer-content" },
        div { className: "footer__card" },
          "this is the footer."
          if @state.user?.token?
            div {},
              div {},
                React.createElement(Material.RaisedButton, { label: "Signout", primary: true, onClick: @logout })
