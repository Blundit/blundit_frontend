{ div } = React.DOM

SessionMixin = require("mixins/SessionMixin")

{ RaisedButton } = Material

module.exports = React.createFactory React.createClass
  mixins: [SessionMixin]

  logout: ->
    UserStore.logout()
    @setUser null

  
  testAddComment: ->
    params = {
      path: "claim_add_comment"
      path_variables:
        claim_id: 1
      data:
        title: "Tester"
        content: "API"
      success: @addCommentSuccess
      error: @addCommentError
    }

    console.log "test add comment"
    API.call(params)


  addCommentSuccess: (data) ->
    console.log "SUCCESS!"
    console.log data


  addCommentError: (error) ->
    console.log "ERROR?!"
    console.log error


  render: ->
    div { className: "footer-wrapper" },
      div { className: "footer-content" },
        "Footer"
        if UserStore.loggedIn()
          div {},
            div
              onClick: @testAddComment
              'Test Add Comment'

            div {},
              React.createElement(RaisedButton, { label: "Signout", primary: true, onClick: @logout })
