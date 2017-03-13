{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
PredictionCard = require("components/PredictionCard")
Pagination = require("components/Pagination")

PaginationMixin = require("mixins/PaginationMixin")

module.exports = React.createFactory React.createClass
  mixins: [PaginationMixin]
  displayName: 'Predictions'


  getInitialState: ->
    predictions: null


  componentDidMount: ->
    @fetchPaginatedData()


  fetchPaginatedData: (id = @state.page) ->
    params = {
      path: "predictions"
      data:
        page: id
      success: @predictionListSuccess
      error: @predictionListError
    }
    API.call(params)


  predictionListSuccess: (data) ->
    @setState predictions: data.predictions
    @setState page: Number(data.page)
    @setState numberOfPages: data.number_of_pages


  predictionListError: (error) ->
    # console.log "error", error


  refToSelf: ->
    @fn = @fn.bind(@)
    @fn

  
  render: ->
    
    div {},
      Header {}, ''
      div { className: "predictions-wrapper" },
        div { className: "predictions-content" },
          div { className: "predictions__list" },
            if @state.predictions?
              @state.predictions.map (prediction, index) ->
                PredictionCard
                  prediction: prediction
                  key: "prediction-card-#{index}"
          if @state.predictions?
            Pagination
              page: @state.page
              numberOfPages: @state.numberOfPages
              nextPage: @nextPage
              previousPage: @previousPage
              specificPage: @specificPage

      Footer {}, ''