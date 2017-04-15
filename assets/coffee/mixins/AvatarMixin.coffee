{ div } = React.DOM

module.exports =
  getExpertAvatar: (expert) ->
    if expert.avatar?
      return expert.avatar
    else
      return "#{API.serverBase()}images/expert_avatars/default.png"

  
  getClaimAvatar: (claim) ->
    if claim.pic?
      return claim.pic
    else
      return "#{API.serverBase()}images/claim_avatars/default.jpg"

  
  getPredictionAvatar: (prediction) ->
    if prediction.pic?
      return prediction.pic
    else
      return "#{API.serverBase()}images/prediction_avatars/default.jpg"


  getUserAvatar: (user) ->
    if user.avatar?
      return user.avatar
    else if user.avatar_url?
      return user.avatar_url
    else
      return "#{API.serverBase()}images/user_avatars/default.png"