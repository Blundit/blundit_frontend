class UserStore
  data: {}
  votes: []
  subscribers: 0
  changeEvent: 'blundit:user'
  fetchMessagesTimeout: null
  lastMessagesFetch: null
  messagesTtl: 60000
  

  loggedIn: ->
    return true if @data and @data.token?
    return false


  dequeueMessagesFetch: =>
    clearTimeout(@fetchMessagesTimeout)
    @fetchMessagesTimeout = null


  subscribe: (callback) =>
    addEventListener(@changeEvent, callback, false)
    @subscribers++
    @emitChange() if @data?


  unsubscribe: (callback) =>
    removeEventListener(@changeEvent, callback)
    @subscribers--
    @dequeueMessagesFetch() unless @subscribers > 0


  emitChange: =>
    event = document.createEvent('Event')
    event.initEvent(@changeEvent, true, true)
    dispatchEvent(event)

  
  updateUserData: (data) ->
    # TODO: optimize this with a proper merge
    @data.first_name = data.first_name
    @data.last_name = data.last_name
    @data.email = data.email
    @data.notification_frequency = data.notification_frequency
    @data.avatar_file_name = data.avatar_file_name
    @emitChange()



  set: (data, request) =>
    @data = data

    if request?
      @data.token = request.getResponseHeader('Access-Token')
      @data.uid = request.getResponseHeader('Uid')
      @data.client = request.getResponseHeader('Client')

    @emitChange()

  
  logout: () ->
    params = {
      path: "logout"
      success: @logoutSuccess
      error: @logoutError
    }

    API.call(params)


  logoutSuccess: ->
    # console.log


  logoutError: ->
    # console.log


  setToken: (token) ->
    @data.token = token

  
  @getAuthHeader: ->
    @user = @get()
    if @user? and @user.token?
      return {
        "Access-Token": @user.token,
        "Token-Type": "Bearer",
        "Client": @user.client,
        "Uid": @user.uid
      }
    else
      return {}


  getAuthHeader: ->
    @user = @get()
    if @user? and @user.token?
      return {
        "Access-Token": @user.token,
        "Token-Type": "Bearer",
        "Client": @user.client,
        "Uid": @user.uid
      }
    else
      return {}


  setUserProfile: (data) ->
    @data.profile = data
    @emitChange()


  doQueueMessages: ->
    if @subscribers > 0
      @queueMessagesFetch()
    else
      @dequeueMessagesFetch()

  
  @get: =>
    @data

  
  get: =>
    @data

  
  updateHeaderInfo: (request) ->
    return if !request.getResponseHeader('Access-Token')?
    @token = request.getResponseHeader('Access-Token')
    @uid = request.getResponseHeader('Uid')
    @client = request.getResponseHeader('Client')

    window.global.setCookie 'Access-Token', @token
    window.global.setCookie 'Uid', @uid
    window.global.setCookie 'Client', @client

    @user = @get()
    @user.token = @token
    @user.uid = @uid
    @user.client = @client


module.exports = new UserStore
  messagestl: 1000 * 60 # 1 minute

