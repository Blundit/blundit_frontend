{ div } = React.DOM

IconButton = Material.IconButton
FontIcon = Material.FontIcon
FlatButton = Material.FlatButton


module.exports = React.createFactory React.createClass
  getInitialState: ->
    page: @props.page
    numberOfPages: @props.numberOfPages
    maxButtonDistance: 2


  drawBackArrow: ->
    return if @props.page == 1
    React.createElement(IconButton, { onClick: @props.goBack },
      React.createElement(FontIcon, { className: "fa fa-angle-double-left" })
    )


  drawNextArrow: ->
    return if @props.page == @props.numberOfPages
    React.createElement(IconButton, { onClick: @props.goNext },
      React.createElement(FontIcon, { className: "fa fa-angle-double-right" })
    )


  goToPage: (id) ->
    @props.goToPage(id)


  drawPages: ->
    div { className: "pagination__pages" },
      for page in [1..@props.numberOfPages]
        if page == @props.page
          React.createElement(FlatButton, { key: "page-#{page}", label: page, disabled: true })
        else
          React.createElement(FlatButton, { key: "page-#{page}", label: page, primary: true, onClick: @goToPage.bind(@, page) })


  render: ->
    return div {} if @props.numberOfPages < 2
    div { className: "pagination" },
      @drawBackArrow()
      @drawPages()
      @drawNextArrow()
