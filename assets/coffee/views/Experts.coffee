{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ExpertCard = require("components/ExpertCard")
Pagination = require("components/Pagination")

PaginationMixin = require("mixins/PaginationMixin")

module.exports = React.createFactory React.createClass
  mixins: [PaginationMixin]
  displayName: 'Experts'

  getInitialState: ->
    experts: null


  componentDidMount: ->
    @fetchPaginatedData()


  fetchPaginatedData: (id = @state.page) ->
    params = {
      path: "experts"
      data:
        page: id
      success: @expertListSuccess
      error: @expertListError
    }
    API.call(params)


  expertListSuccess: (data) ->
    @setState experts: data.experts
    @setState page: Number(data.page)
    @setState numberOfPages: data.number_of_pages


  expertListError: (error) ->
    # console.log "error", error

  
  goToNewExpert: ->
    navigate('/experts/new')


  render: ->
    div {},
      Header {}, ''
      div { className: "experts-wrapper" },
        div { className: "experts-content" },
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