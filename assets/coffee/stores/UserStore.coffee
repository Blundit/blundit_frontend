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
      @data.token = request.getResponseHeader('access-token')
      @data.uid = request.getResponseHeader('uid')
      @data.client = request.getResponseHeader('client')

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
        "access-token": @user.token,
        "client": @user.client,
        "uid": @user.uid
      }
    else
      return {}


  getAuthHeader: ->
    @user = @get()
    if @user? and @user.token?
      return {
        "access-token": @user.token,
        "client": @user.client,
        "uid": @user.uid
      }
    else
      return {}


  fetchUserData: (navigateTarget) ->
    return
    $.ajax
      type: 'GET'
      headers: @getAuthHeader()
      url: @urls.get_user_data
      dataType: 'json'
      success: (data) =>
        @setUserAccounts @fixDates(data)
        @doQueueMessages()
        @fetchUserProfile()
        if navigateTarget?
          window.navigate navigateTarget


  fetchUserProfile: (navigateTarget) ->
    $.ajax
      type: 'GET'
      headers: @getAuthHeader()
      url: @urls.get_current_user
      dataType: 'json'
      success: (data) =>
        @setUserProfile data

    


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
    return if !request.getResponseHeader('access-token')?
    @token = request.getResponseHeader('access-token')
    @uid = request.getResponseHeader('uid')
    @client = request.getResponseHeader('client')

    window.global.setCookie 'access-token', @token
    window.global.setCookie 'uid', @uid
    window.global.setCookie 'client', @client

    @user = @get()
    @user.token = @token
    @user.uid = @uid
    @user.client = @client


module.exports = new UserStore
  messagestl: 1000 * 60 # 1 minute

