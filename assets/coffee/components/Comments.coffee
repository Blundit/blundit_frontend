{ div } = React.DOM

PaginationMixin = require("mixins/PaginationMixin")
Pagination = require("components/Pagination")


module.exports = React.createFactory React.createClass
  displayName: 'Comments'
  mixins: [PaginationMixin]

  getInitialState: ->
    comments: null
    errors: []
    commentSubmitting: false
    commentError: null
    inputs:
      content:
        val: ''
        minLength: 10
  

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
    @setState comments: data.comments
    @setState page: Number(data.page)
    @setState numberOfPages: data.number_of_pages
    @inputs = @state.inputs
    @inputs.content.val = ''
    @setState inputs: @inputs


  commentsError: (error) ->
    # console.log "ERROR"

  
  addComment: ->
    if @validateInputs()
      @setState commentSubmitting: true
      @setState commentError: null
      params = {
        path: "#{@props.type}_add_comment"
        path_variables:
          expert_id: @props.id
          prediction_id: @props.id
          claim_id: @props.id
        data:
          content: @state.inputs.content.val
        success: @addCommentSuccess
        error: @addCommentError
      }
    
      API.call(params)


  validateInputs: ->
    @errors = []
    if @state.inputs.content.val.length < 3
      @errors.push { id: "content", text: "Comment must be at least 3 characters long." }
    
    if @state.inputs.content.val.length > 1000
      @errors.push { id: "content", text: "Comment can't be longer than 1000 characters." }

    @setState errors: @errors

    return true if @errors.length == 0
    return false


  addCommentSuccess: ->
    @setState commentSubmitting: false
    @setState page: 1
    @fetchPaginatedData(1)

  
  addCommentError: (error) ->
    @setState commentSubmitting: false
    if error.responseJSON? and error.responseJSON.errors?
      @setState commentError: error.responseJSON.errors[0]
    else
      @setState commentError: "There was an error."

  formatDate: (date) ->
    return date


  getErrorText: (key) ->
    for error in @state.errors
      if error.id == key
        return error.text
    
    return null


  handleCommentContentChange: (event) ->
    @inputs = @state.inputs
    @inputs.content.val = event.target.value

    @setState inputs: @inputs


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
          div {},
            React.createElement(Material.TextField,
            {
              id: "comment-content",
              hintText: "Add Comment",
              floatingLabelText: "Content",
              multiLine: true,
              rows: 2,
              fullWidth: true,
              rowsMax: 4
              value: @state.inputs.content.val,
              onChange: @handleCommentContentChange,
              errorText: @getErrorText("content")
            })
            div {},
              if @state.commentSubmitting == true
                @style = {
                  display: 'inline-block'
                  position: 'relative'
                  boxShadow: 'none'
                }
                React.createElement(Material.RefreshIndicator, { style: @style, size: 50, left: 0, top: 0, status:"loading" })
              else
                React.createElement(Material.RaisedButton, {label: "Add Comment", primary: true, onClick: @addComment })
            if @state.commentError?
              div {},
                @state.commentError