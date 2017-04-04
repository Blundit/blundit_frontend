{ div, img } = React.DOM

menuItems = [
  { label: "My Bookmarks", path: "/bookmarks", logged: true }
  { label: "Categories", path: "/categories" },
  { label: "Claims", path: "/claims" },
  { label: "Predictions", path: "/predictions" },
  { label: "Experts", path: "/experts" },
  { label: "Search", path: "/search" }
]

LinksMixin = require("mixins/LinksMixin")

LoginModal = require("modals/LoginModal")

module.exports = React.createFactory React.createClass
  mixins: [LinksMixin]
  getInitialState: ->
    user: null
    showLoginModal: false

  handleUserChange: (data) ->
    @setState user: UserStore.get()


  componentDidMount: ->
    UserStore.subscribe(@handleUserChange)

  
  componentWillUnmount: ->
    UserStore.unsubscribe(@handleUserChange)


  navigateToLocation: (path) ->
    navigate(path)


  getUserAvatar: ->
    if !UserStore.get() or !UserStore.get().avatar?
      avatar = "/images/avatars/placeholder.png"
    else
      avatar = "/images/avatars/#{UserStore.get().avatar}"

    return "url(#{avatar})"

  
  showLogin: ->
    @setState showLoginModal: true

  
  hideLogin: ->
    @setState showLoginModal: false

  
  getHeaderItemClass: (item) ->
    @class = "header__item"
    @path = window.location.pathname

    if @path.indexOf(item.path, 0) > -1
      @class += "--active"

    return @class


  render: ->
    div { className: "header-wrapper" },
      div { className: "header" },
        div
          className: "header__logo"
          onClick: @navigateToLocation.bind(@, "/")
          img { src: "/images/logo_wordmark.png" }

        div { className: "header__items" },
          menuItems.map (item, index) =>
            if (item.logged? and @state.user?.token?) or !item.logged
              div
                className: @getHeaderItemClass(item)
                key: "header-item-#{index}"
                onClick: @navigateToLocation.bind(@, item.path)
                item.label
        
        div { className: "header__user" },
          if @state.user?.token?
            div
              className: "header__user__avatar"
              onClick: @navigateToLocation.bind(@, "/me")
              style:
                backgroundImage: @getUserAvatar()
          else
            div {},
              React.createElement(Material.RaisedButton, { label: "Login/Signup", primary: true, onClick: @showLogin })
        if @state.showLoginModal == true
          LoginModal
            hideLogin: @hideLogin
