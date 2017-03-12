module.exports =
  setUser: (data, request) ->
    # window.UserStore.subscribe(@handleUserChange)
    window.UserStore.set data, request
    @user = window.UserStore.get()

    # save cookie
    if @user? and @user.token?
      window.global.setCookie 'access-token', @user.token
      window.global.setCookie 'uid', @user.uid
      window.global.setCookie 'client', @user.client
    else
      window.global.deleteCookie 'access-token'
      window.global.deleteCookie 'uid'
      window.global.deleteCookie 'client'


  getParameterByName: (name, url) ->
    if !url
      url = window.location.href
    name = name.replace(/[\[\]]/g, "\\$&")
    regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)")
    results = regex.exec(url)
    
    if !results
      return null

    if !results[2]
      return ''
    
    return decodeURIComponent(results[2].replace(/\+/g, " "))


  getUrlParams: ->
    query = window.location.search.substring(1)
    raw_vars = query.split("&")

    params = {}

    for v in raw_vars
      [key, val] = v.split("=")
      params[key] = decodeURIComponent(val)

    return params


  getUser: ->
    obj = {}

    @token = window.global.getCookie 'access-token'
    @client = window.global.getCookie 'client'
    @uid = window.global.getCookie 'uid'

    if @token?
      obj.token = @token
      obj.client = @client
      obj.uid = @uid

    return false if obj == {}
    return obj


  unsetUser: ->
    window.UserStore.set null
    window.global.deleteCookie 'access-token'
    window.global.deleteCookie 'client'
    window.global.deleteCookie 'uid'


  authHeader: ->
    @user = window.UserStore.getAuthHeader()
    

  verifyUserToken: ->
    if window.global.getCookie('access-token')
      @verifyToken()
    else
      @setState verificationComplete: true


  verifyToken: ->
    params = {
      path: "verify_token"
      path_variables:
        accessToken: window.global.getCookie('access-token')
        client: window.global.getCookie('client')
        uid: window.global.getCookie('uid')
      success: @verifyTokenSuccess
      error: @verifyTokenError
    }
    
    API.call(params)
    

  verifyTokenSuccess: (data) ->
    if data
      data.data.token = window.global.getCookie('access-token')
      data.data.client = window.global.getCookie('client')
      data.data.uid = window.global.getCookie('uid')
    
      @setUser data.data
    #   # window.UserStore.fetchUserData()
  
      
  verifyTokenError: (error) ->
    @setUser {}

  
  updateUserHeaderInfo: (request) ->