module.exports =
  getInitialState: ->
    page: 1
    numberOfPages: 1


  nextPage: ->
    if @state.page < @state.numberOfPages
      @setState page: @state.page + 1
    
    @fetchPaginatedData(@state.page + 1)

  
  previousPage: ->
    if @state.page > 1
      @setState page: @state.page - 1

    @fetchPaginatedData(@state.page - 1)

  
  specificPage: (page) ->
    @setState page: page

    @fetchPaginatedData(page)