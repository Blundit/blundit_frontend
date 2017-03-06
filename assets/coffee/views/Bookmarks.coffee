{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Bookmarks'

  getInitialState: ->
    bookmarks: null


  componentDidMount: ->
    params = {
      path: "bookmarks"
      success: @getBookmarksSuccess
      error: @getBookmarksError
    }
    API.call(params)


  getBookmarksSuccess: (data) ->
    @setState bookmarks: data

  
  getBookmarksError: (error) ->
    console.log "error"


  showBookmarkNewStatus: (status) ->
    if status == true
      return "!"
    else
      return ""

  
  goToItem: (bookmark) ->
    navigate("/#{bookmark.type}s/#{bookmark.id}")

  
  render: ->
    div {},
      Header {}, ''
      div { className: "bookmarks-wrapper" },
        div { className: "bookmarks-content" },
          div { className: "bookmarks__list" },
            if @state.bookmarks?
              @state.bookmarks.map (bookmark, index) =>
                div
                  className: "bookmarks__list__item"
                  key: "bookmark-#{index}"
                  div
                    className: "bookmarks__list__item-title"
                    onClick: @goToItem.bind(@, bookmark)
                    bookmark.title
                  div
                    className: "bookmarks__list__item-new"
                    @showBookmarkNewStatus(bookmark.new)


      Footer {}, ''