{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ClaimCard = require("components/ClaimCard")
Pagination = require("components/Pagination")
SearchFilters = require("components/SearchFilters")

PaginationMixin = require("mixins/PaginationMixin")
LinksMixin = require("mixins/LinksMixin")
SessionMixin = require("mixins/SessionMixin")

module.exports = React.createFactory React.createClass
  mixins: [PaginationMixin, LinksMixin, SessionMixin]
  displayName: 'Claims'

  getInitialState: ->
    claims: null
    query: @getQuery()
    sort: @getSort()


  componentWillMount: ->
    @fetchPaginatedData()


  fetchPaginatedData: (id = @state.page, query = @state.query, sort = @state.sort) ->
    params = {
      path: "claims"
      data:
        page: id
        query: query
        sort: sort
      success: @claimListSuccess
      error: @claimListError
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


  claimListSuccess: (data) ->
    @setState claims: data.claims
    @setState page: Number(data.page)
    @setState numberOfPages: data.number_of_pages


  claimListError: (error) ->
    # console.log "error", error


  goToNewClaim: ->
    navigate('/claims/new')

  
  search: (query, sort) ->
    @setState page: 1
    @setState query: query
    @setState sort: sort

    window.history.pushState('', 'Blundit - Claims', "#{window.location.origin}/claims?query=#{query}&sort=#{sort}&page=1")

    @fetchPaginatedData(1, query, sort)

  
  getSortOptions: ->
    return [
      { id: 0, title: "Newest" },
      { id: 1, title: "Oldest" },
      { id: 2, title: "Most Recently Updated" },
      { id: 3, title: "Least Recently Updated" },
    ]


  newItemStyle: ->
    return {
      width: "100%"
    }


  render: ->
    div {},
      Header {}, ''
      div { className: "claims-wrapper" },
        div { className: "claims-content" },
          SearchFilters
            sortOptions: @getSortOptions()
            search: @search
          div { className: "default__card" },
            React.createElement(Material.RaisedButton, { label: "Create New Claim", primary: true, onClick: @goToNewClaim, style: @newItemStyle() })
          div { className: "default__card" },
            div { className: "claims__list" },
              if @state.claims?
                @state.claims.map (claim, index) ->
                  ClaimCard
                    claim: claim
                    key: "claim-card-#{index}"
            if @state.claims?
              Pagination
                page: @state.page
                numberOfPages: @state.numberOfPages
                nextPage: @nextPage
                previousPage: @previousPage
                specificPage: @specificPage

      Footer {}, ''