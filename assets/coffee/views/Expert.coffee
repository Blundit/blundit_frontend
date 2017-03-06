{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ExpertClaimCard = require("components/ExpertClaimCard")
ExpertPredictionCard = require("components/ExpertPredictionCard")

module.exports = React.createFactory React.createClass
  displayName: 'Experts'

  getInitialState: ->
    expert: null
    claims: []
    predictions: []
    loadError: null


  componentDidMount: ->
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
                div { className: "expert__predictions" },
                  div { className: "expert__predictions-title" },
                    "Predictions:"
                  div { className: "expert__predictions-list" },
                    if predictions.length > 0
                      predictions.map (prediction, index) ->
                        ExpertPredictionCard
                          expert: expert
                          prediction: prediction
                    else
                      "No predictions"
                div { className: "expert__claims" },
                  div { className: "expert__claims-title" },
                    "Claims:"
                  div { className: "expert__claims-list" },
                    if claims.length > 0
                      claims.map (claim, index) ->
                        ExpertClaimCard
                          expert: expert
                          claim: claim
                          key: "claim-expert-#{index}"
                    else
                      "No claims"
          else
            div {},
              @state.loadError


      Footer {}, ''