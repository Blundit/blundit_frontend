{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
PredictionCard = require("components/PredictionCard")
Pagination = require("components/Pagination")
SearchFilters = require("components/SearchFilters")

PaginationMixin = require("mixins/PaginationMixin")
LinksMixin = require("mixins/LinksMixin")
SessionMixin = require("mixins/SessionMixin")

module.exports = React.createFactory React.createClass
  mixins: [PaginationMixin, LinksMixin, SessionMixin]
  displayName: 'Predictions'


  getInitialState: ->
    predictions: null
    query: @getQuery()
    sort: @getSort()


  componentWillMount: ->
    @fetchPaginatedData()


  fetchPaginatedData: (id = @state.page, query = @state.query, sort = @state.sort) ->
    params = {
      path: "predictions"
      data:
        page: id
        query: query
        sort: sort
      success: @predictionListSuccess
      error: @predictionListError
    }
    API.call(params)


  getQuery: ->
    if @getParameterByName("query")
      return @getParameterByName("query")

    return ''


  getSort: ->
    if @getParameterByName("sort")
      return Number(@getParameterByName("sort"))

    return 0


  search: (query, sort) ->
    @setState page: 1
    @setState query: query
    @setState sort: sort

    window.history.pushState('', 'Blundit - Predictions', "#{window.location.origin}/predictions?query=#{query}&sort=#{sort}&page=1")

    @fetchPaginatedData(1, query, sort)


  predictionListSuccess: (data) ->
    @setState predictions: data.predictions
    @setState page: Number(data.page)
    @setState numberOfPages: data.number_of_pages


  predictionListError: (error) ->
    # console.log "error", error


  goToNewPrediction: ->
    navigate('/predictions/new')


  getSortOptions: ->
    return [
      { id: 0, title: "Newest" },
      { id: 1, title: "Oldest" },
      { id: 2, title: "Most Recently Updated" },
      { id: 3, title: "Least Recently Updated" },
      { id: 4, title: "Most Accurate" },
      { id: 5, title: "Least Accurate" }
    ]


  newItemStyle: ->
    return {
      width: "100%"
    }

  
  render: ->
    div {},
      Header {}, ''
      div { className: "predictions-wrapper" },
        div { className: "predictions-content" },
          SearchFilters
            sortOptions: @getSortOptions()
            search: @search
          div { className: "default__card" },
            React.createElement(Material.RaisedButton, { label: "Create New Prediction", primary: true, onClick: @goToNewPrediction, style: @newItemStyle() })
          div { className: "default__card" },
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