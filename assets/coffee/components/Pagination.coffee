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
    React.createElement(IconButton, { onClick: @props.goBack, className: "pagination__arrow" },
      React.createElement(FontIcon, { className: "fa fa-angle-left" })
    )


  drawNextArrow: ->
    return if @props.page == @props.numberOfPages
    React.createElement(IconButton, { onClick: @props.goNext, className: "pagination__arrow" },
      React.createElement(FontIcon, { className: "fa fa-angle-right" })
    )


  goToPage: (id) ->
    @props.goToPage(id)

  buttonStyle: ->
    return {
      minWidth: "40px",
    }

  
  drawFirstPage: ->
    return if @props.page <= 3

    div { className: "pagination__first" },
      React.createElement(FlatButton, { key: "page-1", label: 1, style: @buttonStyle(), className: "pagination__item", primary: true, onClick: @goToPage.bind(@, 1) })
      if @props.page >= 5
        div { className: "pagination__ellipsis" },
          "..."

  
  drawLastPage: ->
    return if @props.page >= @props.numberOfPages - 2

    div { className: "pagination__last" },
      if @props.page <= @props.numberOfPages - 4
        div { className: "pagination__ellipsis" },
          "..."
      React.createElement(FlatButton, { key: "page-#{@props.numberOfPages}", className: "pagination__item", label: @props.numberOfPages, style: @buttonStyle(), primary: true, onClick: @goToPage.bind(@, @props.numberOfPages) })



  drawPages: ->
    @leftPage = @props.page - 2
    @rightPage = @props.page + 2

    if @props.numberOfPages <= 5
      @leftPage = 1
      @rightPage = @props.numberOfPages

    if @leftPage < 1
      @offset = @leftPage - 1

      @leftPage += Math.abs(@offset)
      @rightPage += Math.abs(@offset)

    if @rightPage > @props.numberOfPages
      @offset = @props.numberOfPages - @rightPage
      @leftPage -= Math.abs(@offset)
      @rightPage -= Math.abs(@offset)

    div { className: "pagination__pages" },
      for page in [@leftPage..@rightPage]
        if page == @props.page
          React.createElement(FlatButton, { key: "page-#{page}", label: page, style: @buttonStyle(), disabled: true })
        else
          React.createElement(FlatButton, { key: "page-#{page}", label: page, style: @buttonStyle(), primary: true, onClick: @goToPage.bind(@, page) })


  render: ->
    return div {} if @props.numberOfPages < 2
    div { className: "pagination" },
      @drawBackArrow()
      @drawFirstPage()
      @drawPages()
      @drawLastPage()
      @drawNextArrow()
