{ div, img, span } = React.DOM

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
    mobileMenu: false


  handleUserChange: (data) ->
    @setState user: UserStore.get()


  componentDidMount: ->
    UserStore.subscribe(@handleUserChange)

  
  componentWillUnmount: ->
    UserStore.unsubscribe(@handleUserChange)


  navigateToLocation: (path) ->
    @setState mobileMenu: false
    scroll(0,0)
    navigate(path)


  getUserAvatar: ->
    if !UserStore.get() or !UserStore.get().avatar_file_name?
      avatar = "/images/avatars/placeholder.png"
    else
      avatar = "http://localhost:3000/images/user_avatars/#{UserStore.get().avatar_file_name}"

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


  getHeaderItemsClass: ->
    @class = "header__items"

  
  getHeaderUserClass: ->
    @class = "header__user"

  
  getHamburgerIcon: ->
    if @state.mobileMenu == true
      span { className: "fa fa-close" }, ''
    else
      span { className: "fa fa-align-justify" }, ''


  toggleMobileMenu: ->
    @setState mobileMenu: !@state.mobileMenu
    
    $("html, body").scrollTop(0)


  render: ->
    div { className: "header-wrapper" },
      div { className: "header" },
        div
          className: "header__logo"
          onClick: @navigateToLocation.bind(@, "/")
          img { src: "/images/logo_wordmark.png" }
        div
          className: "header__hamburger"
          onClick: @toggleMobileMenu
          @getHamburgerIcon()

        div { className: @getHeaderItemsClass() },
          menuItems.map (item, index) =>
            if (item.logged? and @state.user?.token?) or !item.logged
              div
                className: @getHeaderItemClass(item)
                key: "header-item-#{index}"
                onClick: @navigateToLocation.bind(@, item.path)
                item.label
        
        div { className: @getHeaderUserClass() },
          if @state.user?.token?
            div
              className: "header__user__avatar"
              onClick: @navigateToLocation.bind(@, "/me")
              style:
                backgroundImage: @getUserAvatar()
          else
            div {},
              div
                className: "header__login"
                onClick: @showLogin
                span { className: "fa fa-sign-in" }, ''
        if @state.showLoginModal == true
          LoginModal
            hideLogin: @hideLogin

        if @state.mobileMenu == true
          div { className: "mobile-menu" },
            div { className: "header" },
              div
                className: "header__logo"
                onClick: @navigateToLocation.bind(@, "/")
                img { src: "/images/logo_wordmark.png" }
              div
                className: "header__hamburger"
                onClick: @toggleMobileMenu
                @getHamburgerIcon()
            div { className: "mobile-menu__bg" }, ''
            div { className: "mobile-menu__content-wrapper" },
              div { className: "mobile-menu__content" },
                menuItems.reverse().map (item, index) =>
                  if (item.logged? and @state.user?.token?) or !item.logged
                    div
                      className: "mobile-menu__item"
                      key: "mobile-menu__item-#{index}"
                      onClick: @navigateToLocation.bind(@, item.path)
                      item.label