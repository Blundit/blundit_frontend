###
API Class.
Usage to call is like this:
path is required.
path_variables is optional, and used for replacement in paths, like 'claims/%claim_id%/add_commment'
data is optional.

params = {
  path: "claims"
  path_variables:
    claim_id: 1
  data:
    id: "xxx"
  success: @function
  error: @function
}
API.call(params)
###

module.exports = class API
  @paths =
    register:
      path: "users/register"
      method: "POST"
    login:
      path: "users/login"
      method: "POST"
    categories:
      path: "categories"
      method: "GET"
    category:
      path: "categories/%category_id%"
      method: "GET"
    category_predictions:
      path: "categories/%category_id%/predictions"
      method: "GET"
    category_claims:
      path: "categories/%category_id%/claims"
      method: "GET"
    category_experts:
      path: "categories/%category_id%/experts"
      method: "GET"
    category_all:
      path: "categories/%category_id%/all"
      method: "GET"
    claims:
      path: "claims"
      method: "GET"
    claim:
      path: "claims/%claim_id%"
      method: "GET"
    predictions:
      path: "predictions"
      method: "GET"
    prediction:
      path: "predictions/%prediction_id%"
      method: "GET"
    experts:
      path: "experts"
      method: "GET"
    expert:
      path: "experts/%expert_id%"
      method: "GET"
    bookmarks:
      path: "user/bookmarks"
      method: "GET"
    verify_token:
      path: 'auth/verify_token?access-token=%accessToken%&client=%client%&uid=%uid%'
      method: "GET"



  @server = ->
    return "http://localhost:3000/api/v1/"
    
  
  @method = (params) ->
    return @paths[params.path].method


  @path = (params) ->
    @p = @server() + @paths[params.path].path

    for key, value of params.path_variables
      @p = @p.replace '%'+key+'%', value
    
    return @p


  @data = (params) ->
    if params.data?
      data = params.data
    else
      data = {}

    return data


  @call = (params) ->
    $.ajax
      method: @method(params)
      url: @path(params)
      headers:
        Authorization: UserStore.getAuthHeader()
      data: @data(params)
      dataType: "json"
      success: (data) ->
        params.success(data) if params.success?
      error: (error) ->
        params.error(error) if params.error?