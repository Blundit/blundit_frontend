{ div } = React.DOM

menuItems = [
  { label: "My Bookmarks", path: "/bookmarks", logged: true }
  { label: "Me", path: "/me", logged: true },
  { label: "Categories", path: "/categories" },
  { label: "Claims", path: "/claims" },
  { label: "Predictions", path: "/predictions" },
  { label: "Experts", path: "/experts" },
]

module.exports = React.createFactory React.createClass

  navigateToLocation: (path) ->
    navigate(path)


  render: ->
    div {},
      div { className: "header__logo" },
        
        "Blundit"

      div { className: "header__items" },
        menuItems.map (item, index) =>
          
          div
            className: "header__item"
            key: "header-item-#{index}"
            onClick: @navigateToLocation.bind(@, item.path)
            item.label