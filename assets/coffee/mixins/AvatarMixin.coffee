{ div } = React.DOM

module.exports =
  getExpertAvatar: (expert) ->
    if expert.avatar? and expert.avatar.indexOf("placeholder", 0) == -1
      return "#{API.serverBase()}images/expert_avatars/#{expert.avatar}"
    else
      return "#{API.serverBase()}images/expert_avatars/default.png"

  
  getClaimAvatar: (claim) ->
    if claim.pic? and claim.pic.indexOf("placeholder", 0) == -1
      return "#{API.serverBase()}images/claim_avatars/#{claim.pic}"
    else
      return "#{API.serverBase()}images/claim_avatars/default.jpg"

  
  getPredictionAvatar: (prediction) ->
    if prediction.pic? and prediction.pic.indexOf("placeholder", 0) == -1
      return "#{API.serverBase()}images/prediction_avatars/#{prediction.pic}"
    else
      return "#{API.serverBase()}images/prediction_avatars/default.jpg"