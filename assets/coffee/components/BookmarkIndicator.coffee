{ div, span } = React.DOM

module.exports = React.createFactory React.createClass
  updateBookmark: ->
    if @props.bookmark?
      params = {
        path: "remove_bookmark"
        path_variables:
          bookmark_id: @props.bookmark.id
        success: @removeBookmarkSuccess
        error: @removeBookmarkError
      }
    else
      params = {
        path: "add_bookmark"
        data:
          id: @props.id
          type: @props.type
        success: @addBookmarkSuccess
        error: @addBookmarkError
      }
    
    API.call(params)


  removeBookmarkSuccess: (data) ->
    @props.updateBookmark(null)

  
  removeBookmarkError: (error) ->
    # console.log "Error removing bookmark"

  
  addBookmarkSuccess: (data) ->
    @props.updateBookmark(data.bookmark)


  addBookmarkError: (error) ->
    # console.log "Error adding bookmark"


  render: ->
    div
      className: "bookmark-indicator"
      onClick: @updateBookmark
      if @props.bookmark?
        span { className: "fa fa-bookmark" }, ''
      else
        span { className: "fa fa-bookmark-o" }, ''