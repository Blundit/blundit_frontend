{ div } = React.DOM

SessionMixin = require("mixins/SessionMixin")

{ RaisedButton } = Material

module.exports = React.createFactory React.createClass
  mixins: [SessionMixin]

  logout: ->
    UserStore.logout()
    @setUser null


  render: ->
    div { className: "footer-wrapper" },
      div { className: "footer-content" },
        "Footer"
        if UserStore.loggedIn()
          div {},
            React.createElement(RaisedButton, { label: "Signout", primary: true, onClick: @logout })
