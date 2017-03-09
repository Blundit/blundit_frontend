{ div, img } = React.DOM

RaisedButton = Material.RaisedButton

menuItems = [
  { label: "My Bookmarks", path: "/bookmarks", logged: true }
  { label: "Categories", path: "/categories" },
  { label: "Claims", path: "/claims" },
  { label: "Predictions", path: "/predictions" },
  { label: "Experts", path: "/experts" },
]

module.exports = React.createFactory React.createClass
  getInitialState: ->
    user: null

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

  
  getHeaderItemClass: (item) ->
    @class = "header__item"
    @path = window.location.pathname

    if @path.indexOf(item.path, 0) > -1
      @class += "--active"

    return @class

  
  goToLogin: ->
    navigate('/login')


  render: ->
    div { className: "header-wrapper" },
      div { className: "header" },
        div
          className: "header__logo"
          onClick: @navigateToLocation.bind(@, "/")
          img { src: "/images/logo_wordmark.png" }

        div { className: "header__items" },
          menuItems.map (item, index) =>
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
              React.createElement(RaisedButton, { label: "Login/Signup", primary: true, onClick: @goToLogin })

