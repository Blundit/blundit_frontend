{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
PredictionCard = require("components/PredictionCard")
PredictionTextCard = require("components/PredictionTextCard")
ExpertCard = require("components/ExpertCard")
ExpertTextCard = require("components/ExpertTextCard")
ClaimCard = require("components/ClaimCard")

module.exports = React.createFactory React.createClass
  displayName: 'Landing'

  getInitialState: ->
    data: null
    homepageError: false

  componentWillMount: ->
    params = {
      path: "homepage"
      success: @homepageSuccess
      error: @homepageError
    }

    API.call(params)


  homepageSuccess: (data) ->
    @setState data: data
    @setState homepageError: false

  
  homepageError: (error) ->
    if error.responseJSON? and error.responseJSON.errors?
      @setState homepageError: error.responseJSON.errors[0]
    else
      @setState homepageError: "There was an error."
  
  render: ->
    div {},
      Header {}, ''
      div { className: "landing-wrapper" },
        div { className: "landing-content" },
          if !@state.data?
            div {},
              div { className: "default__card" },
                div { className: "not-found" },
                  "Loading..."
          if @state.data?
            div {},
              div { className: "default__card landing__predictions__recent-active" },
                div { className: "text__title" },
                  "Recent Active Predictions"
                if @state.data.most_recent_active_predictions.length > 0
                  @state.data.most_recent_active_predictions.map (prediction, index) ->
                    PredictionCard
                      prediction: prediction
                      key: "most-recent-active-predictions-#{index}"
                else
                  div { className: "not-found" },
                    "No items were found."
              div { className: "default__card landing__predictions__recent-settled" },
                div { className: "text__title" },
                  "Recent Settled Predictions"
                if @state.data.most_recent_settled_predictions.length > 0
                  @state.data.most_recent_settled_predictions.map (prediction, index) ->
                    PredictionCard
                      prediction: prediction
                      key: "most-recent-settled-predictions-#{index}"
                else
                  div { className: "not-found" },
                    "No items were found."

              div { className: "default__card landing__claims__recent-active" },
                div { className: "text__title" },
                  "Recent Active Claims"
                if @state.data.most_recent_active_claims.length > 0
                  @state.data.most_recent_active_claims.map (claim, index) ->
                    ClaimCard
                      claim: claim
                      key: "most-recent-active-claims-#{index}"
                else
                  div { className: "not-found" },
                    "No items were found."
              div { className: "default__card landing__claims__recent-settled" },
                div { className: "text__title" },
                  "Recent Settled Claims"
                if @state.data.most_recent_settled_claims.length > 0
                  @state.data.most_recent_settled_claims.map (claim, index) ->
                    ClaimCard
                      claim: claim
                      key: "most-recent-settled-claims-#{index}"
                else
                  div { className: "not-found" },
                    "No items were found."

              div { className: "default__card landing__experts__text" },
                div { className: "text__title" },
                  "Most Accurate Experts:"
                @state.data.most_accurate_experts.map (expert, index) ->
                  ExpertCard
                    expert: expert
                    key: "most-accurate-experts-#{index}"
              div { className: "default__card landing__experts__text" },
                div { className: "text__title" },
                  "Least Accurate Experts:"
                @state.data.least_accurate_experts.map (expert, index) ->
                  ExpertCard
                    expert: expert
                    key: "least-accurate-experts-#{index}"
              
              
              div { className: "default__card landing__experts__text" },
                div { className: "landing__experts__text-column" },
                  div { className: "text__title" },
                    "Most Popular Experts:"
                  @state.data.most_popular_experts.map (expert, index) ->
                    ExpertTextCard
                      expert: expert
                      key: "most-popular-experts-#{index}"
                div { className: "landing__experts__text-column" },
                  div { className: "text__title" },
                    "Most Popular Claims:"
                  @state.data.most_popular_predictions.map (prediction, index) ->
                    PredictionTextCard
                      prediction: prediction
                      key: "most-popular-predictions-#{index}"

          else if @state.loadError?
            div { className: "default__card" },
              div { className: "landing-error" },
                "Error: #{@state.homepageError}"
          
      Footer {}, ''