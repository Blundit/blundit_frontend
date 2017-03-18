{ div } = React.DOM

PaginationMixin = require("mixins/PaginationMixin")
Pagination = require("components/Pagination")


module.exports = React.createFactory React.createClass
  displayName: 'Comments'
  mixins: [PaginationMixin]

  getInitialState: ->
    comments: null
  

  componentDidMount: ->
    @fetchPaginatedData()

  
  fetchPaginatedData: (id = @state.page) ->
    params = {
      path: "#{@props.type}_comments"
      path_variables:
        expert_id: @props.id,
        prediction_id: @props.id,
        claim_id: @props.id
      data:
        page: id
      success: @commentsSuccess
      error: @commentsError
    }

    API.call(params)

  
  commentsSuccess: (data) ->
    @setState comments: data


  commentsError: (error) ->
    # console.log "ERROR"


  formatDate: (date) ->
    return date


  render: ->
    div { className: "comments" },
      "Comments: #{@props.id}"

      if @state.comments == null
        div {},
          "Loading Comments"
      else if @state.comments.length == 0
        div {},
          "Currently No Comments"

      if @state.comments?
        @state.comments.map (comment, index) =>
          if comment.user?
            div
              className: "comments__comment"
              key: "comment-#{index}"
              div { className: "comments__comment-user" },
                div
                  className: "comments__comment-user-avatar"
                  style:
                    backgroundImage: "url(#{comment.user.avatar_file_name})"
                div { className: "comments__comment-user-name" },
                  comment.user.first_name + " " + comment.user.last_name
              div { className: "comments__comment-meta" },
                div { className: "comments__comment-meta-text" },
                  comment.content
                div { className: "comments__comment-meta-created-at" },
                  @formatDate(comment.created_at)

      if @state.comments?
        Pagination
          page: @state.page
          numberOfPages: @state.numberOfPages
          nextPage: @nextPage
          previousPage: @previousPage
          specificPage: @specificPage

      if @state.comments? and UserStore.loggedIn()
        div { className: "comments__add-comment" },
          "Add comment functionality goes here."