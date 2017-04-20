module.exports =
  setUser: (data, request) ->
    UserStore.set data, request
    @user = UserStore.get()

    # save cookie
    if @user? and @user.token?
      window.global.setCookie 'Access-Token', @user.token
      window.global.setCookie 'Uid', @user.uid
      window.global.setCookie 'Client', @user.client
    else
      window.global.deleteCookie 'Access-Token'
      window.global.deleteCookie 'Uid'
      window.global.deleteCookie 'Client'


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

    @token = window.global.getCookie 'Access-Token'
    @client = window.global.getCookie 'Client'
    @uid = window.global.getCookie 'Uid'

    if @token?
      obj.token = @token
      obj.client = @client
      obj.uid = @uid

    return false if obj == {}
    return obj


  unsetUser: ->
    UserStore.set null
    window.global.deleteCookie 'Access-Token'
    window.global.deleteCookie 'Client'
    window.global.deleteCookie 'Uid'


  authHeader: ->
    @user = UserStore.getAuthHeader()
    

  verifyUserToken: ->
    if window.global.getCookie('Access-Token')
      @verifyToken()
    else
      @setState verificationComplete: true


  verifyToken: ->
    params = {
      path: "verify_token"
      path_variables:
        accessToken: window.global.getCookie('Access-Token')
        client: window.global.getCookie('Client')
        uid: encodeURIComponent(window.global.getCookie('Uid'))
      success: @verifyTokenSuccess
      error: @verifyTokenError
    }
    
    API.call(params)
    

  verifyTokenSuccess: (data) ->
    if data.data
      data.data.token = window.global.getCookie('Access-Token')
      data.data.client = window.global.getCookie('Client')
      data.data.uid = window.global.getCookie('Uid')
    
      @setUser data.data
      
      # TODO: Make user data load go here (additionally)
      UserStore.getUserAvatar()
  
      
  verifyTokenError: (error) ->
    @setUser {}

  