module.exports =
  goToClaim: (id) ->
    navigate("/claims/#{id}")

  
  goToExpert: (id) ->
    navigate("/experts/#{id}")


  goToPrediction: (id) ->
    navigate("/predictions/#{id}")

  
  goToCategory: (id) ->
    navigate("/categories/#{id}")

  
  goToMostRecentClaim: ->
    navigate("/claims/#{@props.expert.most_recent_claim[0].alias}")


  goToMostRecentPrediction: ->
    navigate("/predictions/#{@props.expert.most_recent_prediction[0].alias}")

  
  goToLogin: ->
    navigate('/login')

  
  goBackToSearch: ->
    navigate("/search?query=#{@state.query}&sort=#{@state.sort}")


  logout: ->
    UserStore.logout()
    @setUser {}

  
  goToAbout: ->
    navigate('/about')

  
  goToContact: ->
    navigate('/contact')


  goToPrivacyPolicy: ->
    navigate('/privacy_policy')