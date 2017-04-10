{ div, a, span } = React.DOM

SessionMixin = require("mixins/SessionMixin")
LinksMixin = require("mixins/LinksMixin")

module.exports = React.createFactory React.createClass
  mixins: [SessionMixin, LinksMixin]

  getInitialState: ->
    user: null

  
  componentDidMount: ->
    UserStore.subscribe(@handleUserChange)


  componentWillUnmount: ->
    UserStore.unsubscribe(@handleUserChange)


  handleUserChange: (data) ->
    @setState user: UserStore.get()

  
  render: ->
    div { className: "footer-wrapper" },
      div { className: "footer-content" },
        div { className: "footer__card" },
          div { className: "footer__card-row" },
            div { className: "footer__text" },
              "This has been blundit."
            a
              className: "footer__link"
              onClick: @goToAbout
              'About'
            a
              className: "footer__link"
              onClick: @goToContact
              'Contact'
            a
              className: "footer__link"
              onClick: @goToPrivacyPolicy
              'Privacy Policy'


          div { className: "footer__card-row" },
            div { className: "footer__icons" },
              span { className: "fa fa-facebook" }, ''
              span { className: "fa fa-twitter" }, ''
              span { className: "fa fa-youtube" }, ''
              span { className: "fa fa-podcast" }, ''
            if @state.user?.token?
              div
                className: "footer__link--signout"
                onClick: @logout
                "Sign out"
