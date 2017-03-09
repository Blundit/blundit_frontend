class UserStore
  data: {}
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
    # @queueMessagesFetch()


  unsubscribe: (callback) =>
    removeEventListener(@changeEvent, callback)
    @subscribers--
    @dequeueMessagesFetch() unless @subscribers > 0


  emitChange: =>
    event = document.createEvent('Event')
    event.initEvent(@changeEvent, true, true)
    dispatchEvent(event)


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
      return "Bearer " + @user.token
    else
      return "Bearer 23"


  getAuthHeader: ->
    @user = @get()
    if @user? and @user.token?
      return "Bearer " + @user.token
    else
      return 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.lXpqdZte4jlKBjYo_IK7DhuqVNYh2bQ89U7zQWR4O9w'


  fetchUserData: (navigateTarget) ->
    $.ajax
      type: 'GET'
      headers:
        Authorization: @getAuthHeader()
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
      headers:
        Authorization: @getAuthHeader()
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


module.exports = new UserStore
  messagestl: 1000 * 60 # 1 minute

