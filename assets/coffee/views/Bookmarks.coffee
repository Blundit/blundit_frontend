{ div, span } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Bookmarks'

  getInitialState: ->
    bookmarks: null
    user: null


  componentDidMount: ->
    UserStore.subscribe(@updateUser)


  componentWillUnmount: ->
    UserStore.unsubscribe(@updateUser)


  updateUser: ->
    if @state.bookmarks == null
      @fetchBookmarks()

    @setState user: UserStore.get()

  
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


  getItemClass: (bookmark) ->
    @class = "bookmarks__list__item"

    if bookmark.new == true
      @class += "--has-new"

    return @class

  
  render: ->
    div {},
      Header {}, ''
      div { className: "bookmarks-wrapper" },
        div { className: "bookmarks-content" },
          if @state.user == null
            div { className: "default__card" },
              div { className: "text__title" },
                "My bookmarks"
              div { className: "not-found" },
                "Loading..."

          if @state.user? and !@state.user.token?
            div { className: "default__card" },
              div { className: "text__title" },
                "My bookmarks"
              div { className: "not-found" },
                "You must be logged in to view this content."

          if @state.user? and @state.user.token?
            div { className: "default__card bookmarks__list" },
              div { className: "text__title" },
                "My bookmarks"
              if @state.bookmarks?
                @state.bookmarks.map (bookmark, index) =>
                  div
                    className: @getItemClass(bookmark)
                    key: "bookmark-#{index}"
                    div { className: "bookmarks__list__item-row" },
                      div { className: "bookmarks__list__item-type" },
                        @sentenceCase(bookmark.type) + ": "
                      div
                        className: "bookmarks__list__item-title"
                        onClick: @goToBookmarkItem.bind(@, bookmark)
                        bookmark.title
                      div
                        className: "bookmarks__list__item-new"
                        @showBookmarkNewStatus(bookmark.new)
                    div { className: "bookmarks__list__item-row" },
                      div
                        className: "bookmarks__list__item-notify"
                        onClick: @changeNotificationSettings.bind(@, bookmark)
                        "Notify of updates: "
                        @showNotificationSettings(bookmark)
                      div
                        className: "bookmarks__list__item-remove"
                        onClick: @removeBookmark.bind(@, bookmark)
                        span { className: "fa fa-remove" }, ''
      Footer {}, ''