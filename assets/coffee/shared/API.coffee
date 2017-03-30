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
      path: "auth/"
      non_api: true
      method: "POST"
    login:
      path: "auth/sign_in"
      non_api: true
      method: "POST"
    logout:
      path: "auth/sign_out"
      non_api: true
      method: "DELETE"
    forgot_password:
      path: "auth/password"
      non_api: true
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
    all_claims:
      path: "claims/all"
      method: "GET"
    claim:
      path: "claims/%claim_id%"
      method: "GET"
    create_claim:
      path: "claims/"
      method: "POST"
    claim_add_comment:
      path: "claims/%claim_id%/add_comment"
      method: "POST"
    vote_for_claim:
      path: "claims/%claim_id%/vote"
      method: "POST"
    predictions:
      path: "predictions"
      method: "GET"
    all_predictions:
      path: "predictions/all"
      method: "GET"
    prediction:
      path: "predictions/%prediction_id%"
      method: "GET"
    add_evidence_to_prediction:
      path: "predictions/%prediction_id%/add_evidence"
      method: "POST"
    add_evidence_to_claim:
      path: "claims/%claim_id%/add_evidence"
      method: "POST"
    create_prediction:
      path: "predictions/"
      method: "POST"
    prediction_add_comment:
      path: "predictions/%prediction_id%/add_comment"
      method: "POST"
    vote_for_prediction:
      path: "predictions/%prediction_id%/vote"
      method: "POST"
    experts:
      path: "experts"
      method: "GET"
    all_experts:
      path: "experts/all"
      method: "GET"
    expert:
      path: "experts/%expert_id%"
      method: "GET"
    create_expert:
      path: "experts/"
      method: "POST"
    expert_add_comment:
      path: "experts/%expert_id%/add_comment"
      method: "POST"
    add_prediction_to_expert:
      path: "experts/%expert_id%/add_prediction"
      method: "POST"
    add_claim_to_expert:
      path: "experts/%expert_id%/add_claim"
      method: "POST"
    add_expert_to_prediction:
      path: "predictions/%prediction_id%/add_expert"
      method: "POST"
    add_expert_to_claim:
      path: "claims/%claim_id%/add_expert"
      method: "POST"
    get_substantiations:
      path: "experts/%expert_id%/get_substantiations"
      method: "POST"
    add_substantiation:
      path: "experts/%expert_id%/add_substantiation"
      method: "POST"
    add_bona_fide:
      path: "experts/%expert_id%/add_bona_fide"
      method: "POST"
    bookmarks:
      path: "user/bookmarks"
      method: "GET"
    verify_token:
      path: "auth/validate_token?access-token=%accessToken%&client=%client%&uid=%uid%&"
      method: "GET"
      non_api: true
    expert_comments:
      path: "experts/%expert_id%/comments"
      method: "GET"
    claim_comments:
      path: "claims/%claim_id%/comments"
      method: "GET"
    prediction_comments:
      path: "predictions/%prediction_id%/comments"
      method: "GET"




  @server = (params) ->
    if @paths[params.path].non_api? and @paths[params.path].non_api == true
      return "http://localhost:3000/"
      
    return "http://localhost:3000/api/v1/"
    
  
  @method = (params) ->
    return @paths[params.path].method


  @path = (params) ->
    @p = @server(params) + @paths[params.path].path

    for key, value of params.path_variables
      @p = @p.replace '%'+key+'%', value

    if @paths[params.path].method == "GET"
      @p = @p + @dataAsGet(params.data)

    return @p


  @dataAsGet = (data) ->
    @d = "?"

    for key, value of data
      @d += "#{key}=#{encodeURIComponent(value)}&"

    return @d


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
      headers: UserStore.getAuthHeader()
      data: @data(params)
      dataType: "json"
      success: (data, status, request) ->
        UserStore.updateHeaderInfo(request)
        params.success(data, request) if params.success?
      error: (error) ->
        params.error(error) if params.error?