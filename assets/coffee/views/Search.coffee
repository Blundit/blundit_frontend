{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ClaimCard = require("components/ClaimCard")
PredictionCard = require("components/PredictionCard")
ExpertCard = require("components/ExpertCard")

SearchFilters = require("components/SearchFilters")

LinksMixin = require("mixins/LinksMixin")

module.exports = React.createFactory React.createClass
  displayName: "Search"
  mixins: [LinksMixin]

  getInitialState: ->
    data: null


  getSortOptions: ->
    return [
      { id: 0, title: "Newest" },
      { id: 1, title: "Oldest" },
      { id: 2, title: "Most Recently Updated" },
      { id: 3, title: "Least Recently Updated" }
    ]


  search: (query, sort) ->
    params = {
      path: "search"
      data:
        query: query
        sort: sort
      success: @searchSuccess
      error: @searchError
    }

    API.call(params)


  searchSuccess: (data) ->
    @setState searching: false
    @setState searchError: false
    console.log data
    @setState data: data


  searchError: (error) ->
    @setState searching: false
    if error.responseJSON? and error.responseJSON.errors?
      @setState searchError: error.responseJSON.errors[0]
    else
      @setState searchError: 'There was an error searching.'


  render: ->
    div {},
      Header {}, ''
      div { className: "search-wrapper" },
        div { className: "search-content" },
          SearchFilters
            sortOptions: @getSortOptions()
            search: @search
          if @state.searching == true
            @style = {
              display: 'inline-block'
              position: 'relative'
              boxShadow: 'none'
            }
            React.createElement(Material.RefreshIndicator, { style: @style, size: 50, left: 0, top: 0, status:"loading" })
          if @state.data?
            div {},
              div { className: "search__experts" },
                div { className: "search__experts-title" },
                  "Experts:"
                if @state.data.experts.length == 0
                  div { className: "search__experts-items--empty" },
                    "No expert found for '#{@state.data.query}'"
                else
                  div { className: "search__experts-items" },
                    @state.data.experts.map (expert, index) ->
                      ExpertCard
                        expert: expert
                        key: "search-expert-card-#{index}"

              div { className: "search__predictions" },
                div { className: "search__predictions-title" },
                  "Predictions:"
                if @state.data.predictions.length == 0
                  div { className: "search__predictions-items--empty" },
                    "No prediction found for '#{@state.data.query}'"
                else
                  div { className: "search__predictions-items" },
                    @state.data.predictions.map (prediction, index) ->
                      PredictionCard
                        prediction: prediction
                        key: "search-prediction-card-#{index}"
              div { className: "search__claims" },
                div { className: "search__claims-title" },
                  "Claims:"
                if @state.data.claims.length == 0
                  div { className: "search__claims-items--empty" },
                    "No claim found for '#{@state.data.query}'"
                else
                  div { className: "search__claims-items" },
                    @state.data.claims.map (claim, index) ->
                      ClaimCard
                        claim: claim
                        key: "search-claim-card-#{index}"
          
          if @state.searchError?
            div { className: "search__error" },
              @state.searchError
      Footer {}, ''