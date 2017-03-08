module.exports =
  setUser: (data) ->
    @newUser = data

    window.UserStore.subscribe(@handleUserChange)
    window.UserStore.set data
    @user = window.UserStore.get()

    # save cookie
    if @user? and @user.token?
      @setCookie 'access-token', @user.token
      @setCookie 'uid', @user.uid
      @setCookie 'client', @user.client
    else
      @deleteCookie 'access-token'
      @deleteCookie 'uid'
      @deleteCookie 'client'


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

    @token = @getCookie 'access-token'
    @client = @getCookie 'client'
    @uid = @getCookie 'uid'

    if @token?
      obj.token = @token
      obj.client = @client
      obj.uid = @uid

    return false if obj == {}
    return obj


  unsetUser: ->
    window.UserStore.set null
    @deleteCookie 'access-token'
    @deleteCookie 'client'
    @deleteCookie 'uid'


  authHeader: ->
    @user = window.UserStore.getAuthHeader()
    

  verifyUserToken: ->
    if @getCookie('access-token')
      @verifyToken()
    else
      @setState verificationComplete: true


  verifyToken: ->
    params = {
      path: "verify_token"
      path_variables:
        accessToken: @getCookie('access-token')
        client: @getCookie('client')
        uid: @getCookie('uid')
      success: @verifyTokenSuccess
      error: @verifyTokenError
    }
    
    API.call(params)

  verifyTokenSuccess: (data) ->
    if data.code == 200
      @setUser {
        token: @getCookie('access-token')
        client: @getCookie('client')
        uid: @getCookie('uid')

      }
      window.UserStore.fetchUserData()
    
  verifyTokenError: (error) ->
    @setUser null


  setCookie: (name, value, days) ->
    if days
      date = new Date()
      date.setTime date.getTime() + (days * 24 * 60 * 60 * 1000)
      expires = "; expires=" + date.toGMTString()
    else
      expires = ""
    document.cookie = name + "=" + value + expires + "; path=/"


  getCookie: (name) ->
    nameEQ = name + "="
    ca = document.cookie.split(";")
    i = 0

    while i < ca.length
      c = ca[i]
      c = c.substring(1, c.length)  while c.charAt(0) is " "
      return c.substring(nameEQ.length, c.length)  if c.indexOf(nameEQ) is 0
      i++
    null


  deleteCookie: (name) ->
    @setCookie name, "", -1