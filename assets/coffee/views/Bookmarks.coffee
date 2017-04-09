{ div, span } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Bookmarks'

  getInitialState: ->
    bookmarks: null


  componentDidMount: ->
    @fetchBookmarks()

  
  fetchBookmarks: ->
    params = {
      path: "bookmarks"
      success: @getBookmarksSuccess
      error: @getBookmarksError
    }
    API.call(params)


  getBookmarksSuccess: (data) ->
    @setState bookmarks: data

  
  getBookmarksError: (error) ->
    # console.log "error"


  showBookmarkNewStatus: (status) ->
    if status == true
      return span { className: "fa fa-asterisk"}, ''
    else
      return ""

  
  goToBookmarkItem: (bookmark) ->
    navigate("/#{bookmark.type}s/#{bookmark.alias}")

  
  sentenceCase: (text) ->
    # TODO: Add this to universal mixin/class
    return text.replace(/\w\S*/g,
      (text) ->
        return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase()
    )

  
  changeNotificationSettings: (bookmark) ->
    @notify = !bookmark.notify

    params = {
      path: "update_bookmark"
      path_variables:
        bookmark_id: bookmark.id
      data:
        notify: @notify
      success: @changeNotificationSuccess
      error: @changeNotificationError
    }

    API.call(params)

  
  changeNotificationSuccess: (data) ->
    @fetchBookmarks()


  changeNotificationError: (error) ->
    # console.log error


  showNotificationSettings: (bookmark) ->
    if bookmark.notify == true
      span { className: "fa fa-envelope" }, ''
    else
      span { className: "fa fa-envelope-o" }, ''



  removeBookmark: (bookmark) ->
    params = {
      path: "remove_bookmark"
      path_variables:
        bookmark_id: bookmark.id
      success: @removeBookmarkSuccess
      error: @removeBookmarkError
    }

    API.call(params)


  removeBookmarkSuccess: (data) ->
    @fetchBookmarks()

  
  removeBookmarkError: (error) ->
    # console.log error

  
  render: ->
    div {},
      Header {}, ''
      div { className: "bookmarks-wrapper" },
        div { className: "bookmarks-content" },
          div { className: "default__card bookmarks__list" },
            if @state.bookmarks?
              @state.bookmarks.map (bookmark, index) =>
                div
                  className: "bookmarks__list__item"
                  key: "bookmark-#{index}"
                  div {},
                    div { className: "bookmarks__list__item-type" },
                      @sentenceCase(bookmark.type) + ": "
                    div
                      className: "bookmarks__list__item-title"
                      onClick: @goToBookmarkItem.bind(@, bookmark)
                      bookmark.title
                    div
                      className: "bookmarks__list__item-new"
                      @showBookmarkNewStatus(bookmark.new)
                  div {},
                    div
                      className: "bookmarks__list__item-notify"
                      onClick: @changeNotificationSettings.bind(@, bookmark)
                      @showNotificationSettings(bookmark)
                    div
                      className: "bookmarks__list__item-remove"
                      onClick: @removeBookmark.bind(@, bookmark)
                      span { className: "fa fa-remove" }, ''




      Footer {}, ''