{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ClaimCard = require("components/ClaimCard")
Pagination = require("components/Pagination")

PaginationMixin = require("mixins/PaginationMixin")

module.exports = React.createFactory React.createClass
  mixins: [PaginationMixin]
  displayName: 'Claims'

  getInitialState: ->
    claims: null


  componentDidMount: ->
    @fetchPaginatedData()


  fetchPaginatedData: (id = @state.page) ->
    params = {
      path: "claims"
      data:
        page: id
      success: @claimListSuccess
      error: @claimListError
    }
    API.call(params)


  claimListSuccess: (data) ->
    @setState claims: data.claims
    @setState page: Number(data.page)
    @setState numberOfPages: data.number_of_pages


  claimListError: (error) ->
    # console.log "error", error


  render: ->
    div {},
      Header {}, ''
      div { className: "claims-wrapper" },
        div { className: "claims-content" },
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