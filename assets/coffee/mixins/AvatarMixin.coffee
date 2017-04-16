{ div } = React.DOM

module.exports =
  getExpertAvatar: (expert) ->
    if expert.avatar? and expert.avatar.indexOf("http:", 0) > -1
      return expert.avatar
    else
      return "#{API.serverBase()}images/expert_avatars/default.png"

  
  getClaimAvatar: (claim) ->
    if claim.pic? and claim.pic.indexOf("http:", 0) > -1
      return claim.pic
    else
      return "#{API.serverBase()}images/claim_avatars/default.jpg"

  
  getPredictionAvatar: (prediction) ->
    if prediction.pic? and prediction.pic.indexOf("http:", 0) > -1
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