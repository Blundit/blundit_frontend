{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
PredictionCard = require("components/PredictionCard")
ExpertCard = require("components/ExpertCard")
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
          if @state.data?
            div {},
              div { className: "landing__predictions__recent-active" },
                "Recent Active Predictions:"
                @state.data.most_recent_active_predictions.map (prediction, index) ->
                  PredictionCard
                    prediction: prediction
                    key: "most-recent-active-predictions-#{index}"
              div { className: "landing__predictions__recent-settled" },
                "Recent Settled Predictions:"
                @state.data.most_recent_settled_predictions.map (prediction, index) ->
                  PredictionCard
                    prediction: prediction
                    key: "most-recent-settled-predictions-#{index}"
              div { className: "landing__claims__recent-active" },
                "Recent Active Claims:"
                @state.data.most_recent_active_claims.map (claim, index) ->
                  ClaimCard
                    claim: claim
                    key: "most-recent-active-claims-#{index}"
              div { className: "landing__claims__recent-settled" },
                "Recent Settled Claims:"
                @state.data.most_recent_settled_claims.map (claim, index) ->
                  ClaimCard
                    claim: claim
                    key: "most-recent-settled-claims-#{index}"
              div { className: "landing__experts__random" },
                "Random Expert:"
                ExpertCard
                  expert: @state.data.random_expert
                  
              div { className: "landing__claim__random" },
                "Random Claim:"
                ClaimCard
                  claim: @state.data.random_claim
                  key: "random-claim"
              div { className: "landing__predictions__random" },
                "Random Prediction:"
                PredictionCard
                  prediction: @state.data.random_prediction
                  key: "random-prediction"
              div { className: "landing__experts__most-accurate" },
                "Most accurate Experts:"
                @state.data.most_accurate_experts.map (claim, index) ->
                  ExpertCard
                    expert: claim
                    key: "most-accurate-experts-#{index}"
              div { className: "landing__experts__least-accurate" },
                "Least accurate Experts:"
                @state.data.most_accurate_experts.map (claim, index) ->
                  ExpertCard
                    expert: claim
                    key: "most-accurate-experts-#{index}"

          else if @state.loadError?
            div { className: "landing-error" },
              "Error: #{@state.homepageError}"
          
      Footer {}, ''