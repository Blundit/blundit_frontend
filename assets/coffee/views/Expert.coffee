{ div, img, span, input, a } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ExpertClaimCard = require("components/ExpertClaimCard")
ExpertPredictionCard = require("components/ExpertPredictionCard")
ExpertBonaFides = require("components/ExpertBonaFides")
Comments = require("components/Comments")
AddToExpert = require("components/AddToExpert")
BookmarkIndicator = require("components/BookmarkIndicator")
ImageUpload = require("components/ImageUpload")

SessionMixin = require("mixins/SessionMixin")
LinksMixin = require("mixins/LinksMixin")
AvatarMixin = require("mixins/AvatarMixin")

module.exports = React.createFactory React.createClass
  mixins: [SessionMixin, LinksMixin, AvatarMixin]
  displayName: 'Experts'

  getInitialState: ->
    expert: null
    claims: []
    predictions: []
    loadError: null
    showCreated: @doShowCreated()


  componentDidMount: ->
    @fetchExpert()


  fetchExpert: ->
    params = {
      path: "expert"
      path_variables:
        expert_id: @props.id
      success: @expertSuccess
      error: @expertError
    }
    API.call(params)


  expertSuccess: (data) ->
    @setState expert: data.expert
    @setState claims: data.claims
    @setState predictions: data.predictions


  expertError: (error) ->
    if error.responseJSON? and error.responseJSON.errors?
      @setState loadError: error.responseJSON.errors

  
  updateBookmark: (data) ->
    @expert = @state.expert
    @expert.bookmark = data
    @setState expert: @expert

  
  goToBonaFide: (url) ->
    window.open url, '_blank'

  
  categoryMaterialStyle: ->
    { margin: 4 }


  showAccuracy: (val) ->
    Math.floor(val*100)+"%"

  
  successCardStyle: ->
    {
      backgroundColor: "#237a0b"
      color: "#ffffff"
      margin: 4
    }

  removeAlert: ->
    @setState showCreated: false

  
  doShowCreated: ->
    if @getParameterByName("created") == 1 or @getParameterByName("created") == "1"
      return true
    else
      return false

  
  showNewExpertText: ->
    div { className: "expert__created" },
      if @state.showCreated == true
        React.createElement(Material.Chip, {
          style: @successCardStyle(),
          onRequestDelete: @removeAlert
        },
          "Success! You've added a new expert to the system. Now you can add more information to them!"
        )


  expertDescription: ->
    { expert } = @state
    if expert.description? and expert.description > ''
      return expert.description
    else
      return span { className: "not-found" }, "This expert has no description yet."

  
  getExpertAttribute: (expert, attribute) ->
    @na = "N/A"
    if expert[attribute]? and expert[attribute].trim() > ""
      @att = expert[attribute].trim()
    else
      @att = @na

    if attribute == "website" and @att != @na
      return a { href: @att, target: "_blank" }, @att
    if attribute == "twitter" and @att != @na
      return a { href: "https://www.twitter.com/#{@att}", target: "_blank" }, @att
    if attribute == "facebook" and @att != @na
      return a { href: "https://www.facebook.com/#{@att}", target: "_blank" }, @att
    if attribute == "instagram" and @att != @na
      return a { href: "http://www.instagram.com/#{@att}", target: "_blank" }, @att
    if attribute == "youtube" and @att != @na
      return a { href: "http://www.youtube.com/channels/#{@att}", target: "_blank" }, @att

    return @att

  
  render: ->
    { expert, predictions, claims } = @state

    div {},
      Header {}, ''
      div { className: "experts-wrapper" },
        div { className: "experts-content" },
          if expert?
            div { className: "expert" },
              @showNewExpertText()
              div { className: "default__card" },
                div { className: "text__title expert__name" },
                  expert.name
                div
                  className: "expert__avatar"
                  style:
                    backgroundImage: "url(#{@getExpertAvatar(expert)})"
                  if UserStore.loggedIn()
                    ImageUpload
                      type: "expert"
                      item_id: expert.id
                      refresh: @fetchExpert
                div { className: "expert__meta" },
                  div { className: "expert__meta-occupation" },
                    "Occupation #{@getExpertAttribute(expert, 'occupation')}"
                  div { className: "expert__meta-description" },
                    @expertDescription()
                  div { className: "expert__meta-website" },
                    "Website: #{@getExpertAttribute(expert, 'website')}"
                  div { className: "expert__meta-location" },
                    "Location: #{@getExpertAttribute(expert, 'city')}, #{@getExpertAttribute(expert, 'country')}"
                  div { className: "expert__meta-twitter" },
                    "Twitter: "
                    @getExpertAttribute(expert, 'twitter')
                  div { className: "expert__meta-facebook" },
                    "Facebook:"
                    @getExpertAttribute(expert, 'facebook')
                  div { className: "expert__meta-instagram" },
                    "Instagram: "
                    @getExpertAttribute(expert, 'instagram')
                  div { className: "expert__meta-youtube" },
                    "Youtube Channel: "
                    @getExpertAttribute(expert, 'youtube')
                if UserStore.loggedIn()
                  div { className: "expert__bookmark" },
                    BookmarkIndicator
                      bookmark: @state.expert.bookmark
                      type: "expert"
                      id: @state.expert.id
                      updateBookmark: @updateBookmark

              div { className: "default__card expert__categories" },
                div { className: "text__title" },
                  "Categories"
                div { className: "text__normal" },
                  "These are the categories this expert is connected to:"
                if expert.categories.length == 0
                  div { className: "not-found" },
                    "No categories yet."
                else
                  div {},
                    expert.categories.map (category, index) =>
                      React.createElement( Material.Chip,
                        { onTouchTap: @goToCategory.bind(@, category.id), key: "expert-category-chip-#{index}", style: @categoryMaterialStyle() },
                        category.name
                      )


              div { className: "default__card expert__accuracy" },
                "This expert has an overall accuracy of: #{@showAccuracy(expert.accuracy)}"

                div { className: "expert__accuracy-categories" },
                  "Accuracy by Category: "
                  if expert.category_accuracies.length > 0
                    expert.category_accuracies.map (accuracy, index) =>
                      div
                        className: "expert__accuracy-category"
                        key: "expert-accuracy-category-#{index}"
                        div { className: "expert__accuracy-category__name" },
                          "#{accuracy.category_name}"
                        div { className: "expert__accuracy-category__claim" },
                          "Claims: #{@showAccuracy(accuracy.claim_accuracy)} (#{accuracy.correct_claims}/#{accuracy.correct_claims + accuracy.incorrect_claims} C)"
                        div { className: "expert__accuracy-category__prediction" },
                          "Predictions: #{@showAccuracy(accuracy.prediction_accuracy)} (#{accuracy.correct_predictions}/#{accuracy.correct_predictions + accuracy.incorrect_predictions} P)"
                  else
                    div { className: "not-found" },
                      "No category accuracies to display."
                    

              ExpertBonaFides
                expert: expert
                refresh: @fetchExpert

              div { className: "default__card expert__predictions" },
                div { className: "text__title" },
                  "Predictions this expert has made:"
                div { className: "expert__predictions-list" },
                  if predictions.length > 0
                    predictions.map (prediction, index) ->
                      ExpertPredictionCard
                        expert: expert
                        key: "expert-prediction-card-#{index}"
                        prediction: prediction
                  else
                    div { className: "not-found" },
                      "No predictions"
                  AddToExpert
                    expert: expert
                    type: "prediction"
                    items: @state.predictions
                    refresh: @fetchExpert

              div { className: "default__card expert__claims" },
                div { className: "text__title" },
                  "Claims this expert has made:"
                div { className: "expert__claims-list" },
                  if claims.length > 0
                    claims.map (claim, index) ->
                      ExpertClaimCard
                        expert: expert
                        claim: claim
                        key: "expert-claim-card-#{index}"
                  else
                    div { className: "not-found" },
                      "No claims found."
                  if UserStore.loggedIn()
                    AddToExpert
                      expert: expert
                      type: "claim"
                      items: @state.claims
                      refresh: @fetchExpert
              Comments
                type: "expert"
                item: expert
                id: expert.id
                num: expert.comments_count
          else
            div {},
              @state.loadError


      Footer {}, ''