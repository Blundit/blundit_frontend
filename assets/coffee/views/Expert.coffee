{ div, img } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ExpertClaimCard = require("components/ExpertClaimCard")
ExpertPredictionCard = require("components/ExpertPredictionCard")
Comments = require("components/Comments")
AddToExpert = require("components/AddToExpert")

module.exports = React.createFactory React.createClass
  displayName: 'Experts'

  getInitialState: ->
    expert: null
    claims: []
    predictions: []
    loadError: null


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
    @setState loadError: error.responseJSON.errors

  
  goToBonaFide: (url) ->
    window.open url, '_blank'

  
  goToCategory: (id) ->
    navigate("/categories/#{id}")


  categoryMaterialStyle: ->
    return { margin: 4 }


  showAccuracy: (val) ->
    return Math.floor(val*100)+"%"

  
  render: ->
    { expert, predictions, claims } = @state

    div {},
      Header {}, ''
      div { className: "experts-wrapper" },
        div { className: "experts-content" },
          
          if expert?
            div { className: "expert" },
                div { className: "expert__name" },
                  expert.name
                div { className: "expert__description" },
                  if expert.description?
                    expert.description
                  else
                    "This expert has no description yet."
                div { className: "expert__avatar" },
                  img { src: expert.avatar }

                div { className: "expert__bona-fides" },
                  if expert.bona_fides.length == 0
                    "This expert has no bona fides listed yet."
                  else
                    expert.bona_fides.map (bona_fide, index) =>
                      div
                        className: "expert__bona-fide"
                        key: "expert-bona-fide-#{index}"
                        div { className: "expert__bona-fide__title" },
                          bona_fide.title
                        div { className: "expert__bona-fide__description" },
                          bona_fide.description
                        div
                          className: "expert__bona-fide__url"
                          onClick: @goToBonaFide.bind(@, bona_fide.url)
                          bona_fide.url

                div { className: "expert__categories" },
                  "These are the titles belonging to this expert:"
                  if expert.categories.length == 0
                    div {},
                      "No categories yet."
                  else
                    div {},
                      expert.categories.map (category, index) =>
                        React.createElement( Material.Chip,
                          { onTouchTap: @goToCategory.bind(@, category.id), key: "expert-category-chip-#{index}", style: @categoryMaterialStyle() },
                          category.name
                        )

                div { className: "expert__accuracy" },
                  "This expert has an overall accuracy of: #{@showAccuracy(expert.accuracy)}"

                  div { className: "expert__accuracy-categories" },
                    "Accuracy by Category: "
                    expert.category_accuracies.map (accuracy, index) =>
                      div
                        className: "expert__accuracy-category"
                        key: "expert-accuracy-category-#{index}"
                        "#{accuracy.category_name}"
                        div { className: "expert__accuracy-category__claim" },
                          "#{@showAccuracy(accuracy.claim_accuracy)} (Claims: #{accuracy.correct_claims + accuracy.incorrect_claims})"
                        div { className: "expert__accuracy-category__prediction" },
                          "#{@showAccuracy(accuracy.prediction_accuracy)} (Predictions: #{accuracy.correct_predictions + accuracy.incorrect_predictions})"
                      

                div { className: "expert__predictions" },
                  div { className: "expert__predictions-title" },
                    "Predictions:"
                  div { className: "expert__predictions-list" },
                    if predictions.length > 0
                      predictions.map (prediction, index) ->
                        ExpertPredictionCard
                          expert: expert
                          key: "expert-prediction-card-#{index}"
                          prediction: prediction
                    else
                      "No predictions"
                    if UserStore.loggedIn()
                      AddToExpert
                        expert: expert
                        type: "prediction"
                        items: @state.predictions
                        refresh: @fetchExpert
                div { className: "expert__claims" },
                  div { className: "expert__claims-title" },
                    "Claims:"
                  div { className: "expert__claims-list" },
                    if claims.length > 0
                      claims.map (claim, index) ->
                        ExpertClaimCard
                          expert: expert
                          claim: claim
                          key: "expert-claim-card-#{index}"
                    else
                      "No claims"
                    if UserStore.loggedIn()
                      AddToExpert
                        expert: expert
                        type: "claim"
                        items: @state.claims
                        refresh: @fetchExpert

                    
                Comments
                  type: "expert"
                  id: expert.id
                  num: expert.comments_count
          else
            div {},
              @state.loadError


      Footer {}, ''