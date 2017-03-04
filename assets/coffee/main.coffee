window.React = require('react')
window.ReactDOM = require('react-dom')
RouterMixin = require('react-mini-router').RouterMixin
window.navigate = require('react-mini-router').navigate
window._ = require('lodash')

window.UserStore = UserStore = require("stores/UserStore")
window.API = require("shared/API")

Header = require("./components/Header")
Footer = require("./components/Footer")

{ div } = React.DOM

Blundit = React.createFactory React.createClass
  mixins: [RouterMixin]

  componentWillMount: ->
    # console.log "will mount"


  componentWillUnmount: ->
    # console.log "will componentWillUnmount"


  routes:
    '/': 'landing'
    '/me': 'userProfile'
    '/bookmarks': 'bookmarks'
    '/users': 'users'
    '/users/:id': 'user'
    '/register': 'userRegister'
    '/login': 'userLogin'
    '/predictions': 'predictions'
    '/predictions/:id': 'prediction'
    '/experts': 'experts'
    '/experts/:id': 'expert'
    '/claims': 'claims'
    '/claims/:id': 'claim'
    

  landing: ->
    div {},
      require("views/Landing")
        path: @state.path


  users: ->
    div {},
      require("views/Users")
        path: @state.path

  
  user: (id) ->
    div {},
      require("views/User")
        path: @state.path
        user_id: id

  
  userProfile: ->
    div {},
      require("views/User")
        path: @state.path
        me: true


  predictions: ->
    div {},
      require("views/Predictions")
        path: @state.path

  
  prediction: (id) ->
    div {},
      require("views/Prediction")
        path: @state.path
        user_id: id


  claims: ->
    div {},
      require("views/Claims")
        path: @state.path

  
  claim: (id) ->
    div {},
      require("views/Claim")
        path: @state.path
        user_id: id


  experts: ->
    div {},
      require("views/Experts")
        path: @state.path

  
  expert: (id) ->
    div {},
      require("views/Expert")
        path: @state.path
        user_id: id


  bookmarks: ->
    div {},
      require("views/Bookmarks")
        path: @state.path


  
  notFound: (path) ->
    div {},
      require("views/404") {}


  render: ->
    params = {
      path: "claims"
      path_variables:
        claim_id: 1
      data:
        id: "xxx"
    }
    API.call(params)
    div {},
    
      @renderCurrentRoute()


startBlundit = ->
  if document.getElementById('app')?
    ReactDOM.render(
      Blundit { history: true }
      document.getElementById('app')
    )

if window.addEventListener
  window.addEventListener('DOMContentLoaded', startBlundit)
else
  window.attachEvent('onload', startBlundit)
