{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ClaimCard = require("components/ClaimCard")
PredictionCard = require("components/PredictionCard")
ExpertCard = require("components/ExpertCard")

SearchFilters = require("components/SearchFilters")

LinksMixin = require("mixins/LinksMixin")
SessionMixin = require("mixins/SessionMixin")

module.exports = React.createFactory React.createClass
  displayName: "Search"
  mixins: [LinksMixin, SessionMixin]

  getInitialState: ->
    data: null
    query: @getQuery()
    sort: @getSort()
    searchError: null

  
  componentDidMount: ->
    @search(@state.query, @state.sort)

  
  getQuery: ->
    if @getParameterByName("query")
      return @getParameterByName("query")

    return ''


  getSort: ->
    if @getParameterByName("sort")
      return Number(@getParameterByName("sort"))

    return 0


  getSortOptions: ->
    return [
      { id: 0, title: "Newest" },
      { id: 1, title: "Oldest" },
      { id: 2, title: "Most Recently Updated" },
      { id: 3, title: "Least Recently Updated" }
    ]


  search: (query, sort) ->
    window.history.pushState('', 'Blundit - Search', "#{window.location.origin}/search?query=#{query}&sort=#{sort}")
    params = {
      path: "search"
      data:
        query: query
        sort: sort
      success: @searchSuccess
      error: @searchError
    }

    API.call(params)

    @setState query: query
    @setState sort: sort


  searchSuccess: (data) ->
    @setState searching: false
    @setState searchError: null
    @setState data: data


  searchError: (error) ->
    @setState searching: false
    if error.responseJSON? and error.responseJSON.errors?
      @setState searchError: error.responseJSON.errors[0]
    else
      @setState searchError: 'There was an error searching.'


  goToClaims: ->
    @url = "/claims?query=#{@state.query}&sort=#{@state.sort}&from_search=1"

    navigate(@url)

  
  goToPredictions: ->
    @url = "/predictions?query=#{@state.query}&sort=#{@state.sort}&from_search=1"

    navigate(@url)


  goToExperts: ->
    @url = "/experts?query=#{@state.query}&sort=#{@state.sort}&from_search=1"

    navigate(@url)


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
            div { className: "default__card" },
              React.createElement(Material.RefreshIndicator, { style: @style, size: 50, left: 0, top: 0, status:"loading" })
          if @state.data?
            div { className: "" },
              div { className: "default__card search__experts" },
                div { className: "text__title" },
                  "Experts:"
                if @state.data.experts.length == 0
                  div { className: "search__experts-items--empty" },
                    "No expert found for '#{@state.data.query}'"
                else
                  div {},
                    div { className: "search__experts-items" },
                      @state.data.experts.map (expert, index) ->
                        ExpertCard
                          expert: expert
                          key: "search-expert-card-#{index}"
                    div {},
                      React.createElement(Material.RaisedButton, { label: "View All", primary: true, onClick: @goToExperts })
              div { className: "default__card search__predictions" },
                div { className: "text__title" },
                  "Predictions:"
                if @state.data.predictions.length == 0
                  div { className: "search__predictions-items--empty" },
                    "No prediction found for '#{@state.data.query}'"
                else
                  div {},
                    div { className: "search__predictions-items" },
                      @state.data.predictions.map (prediction, index) ->
                        PredictionCard
                          prediction: prediction
                          key: "search-prediction-card-#{index}"
                    div {},
                      React.createElement(Material.RaisedButton, { label: "View All", primary: true, onClick: @goToPredictions })
              div { className: "default__card search__claims" },
                div { className: "text__title" },
                  "Claims:"
                if @state.data.claims.length == 0
                  div { className: "search__claims-items--empty" },
                    "No claim found for '#{@state.data.query}'"
                else
                  div {},
                    div { className: "search__claims-items" },
                      @state.data.claims.map (claim, index) ->
                        ClaimCard
                          claim: claim
                          key: "search-claim-card-#{index}"
                    div {},
                      React.createElement(Material.RaisedButton, { label: "View All", primary: true, onClick: @goToClaims })
          
          if @state.searchError?
            div { className: "default__card search__error" },
              @state.searchError
      Footer {}, ''