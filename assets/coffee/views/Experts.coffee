{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ExpertCard = require("components/ExpertCard")
Pagination = require("components/Pagination")
SearchFilters = require("components/SearchFilters")

PaginationMixin = require("mixins/PaginationMixin")
LinksMixin = require("mixins/LinksMixin")
SessionMixin = require("mixins/SessionMixin")

module.exports = React.createFactory React.createClass
  mixins: [PaginationMixin, LinksMixin, SessionMixin]
  displayName: 'Experts'

  getInitialState: ->
    experts: null
    query: @getQuery()
    sort: @getSort()


  componentWillMount: ->
    @fetchPaginatedData()


  fetchPaginatedData: (id = @state.page, query = @state.query, sort = @state.sort) ->
    params = {
      path: "experts"
      data:
        page: id
        query: query
        sort: sort
      success: @expertListSuccess
      error: @expertListError
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


  expertListSuccess: (data) ->
    @setState experts: data.experts
    @setState page: Number(data.page)
    @setState numberOfPages: data.number_of_pages


  expertListError: (error) ->
    # console.log "error", error

  
  goToNewExpert: ->
    navigate('/experts/new')


  search: (query, sort) ->
    @setState page: 1
    @setState query: query
    @setState sort: sort

    window.history.pushState('', 'Blundit - Experts', "http://localhost:8888/experts?query=#{query}&sort=#{sort}&page=1")

    @fetchPaginatedData(1, query, sort)

  
  getSortOptions: ->
    return [
      { id: 0, title: "Newest" },
      { id: 1, title: "Oldest" },
      { id: 2, title: "Most Recently Updated" },
      { id: 3, title: "Least Recently Updated" },
      { id: 4, title: "Most Accurate" },
      { id: 5, title: "Least Accurate" }
    ]


  render: ->
    div {},
      Header {}, ''
      div { className: "experts-wrapper" },
        div { className: "experts-content" },
          if @getParameterByName("from_search")?
            div
              className: "predictions__back-to-search"
              onClick: @goBackToSearch
              'Back to Search'
          SearchFilters
            sortOptions: @getSortOptions()
            search: @search
          React.createElement(Material.RaisedButton, { label: "Create New Expert", primary: true, onClick: @goToNewExpert })
          div { className: "experts__list" },
            if @state.experts?
              @state.experts.map (expert, index) ->
                ExpertCard
                  expert: expert
                  key: "expert-card-#{index}"
          if @state.experts?
            Pagination
              page: @state.page
              numberOfPages: @state.numberOfPages
              nextPage: @nextPage
              previousPage: @previousPage
              specificPage: @specificPage

      Footer {}, ''