{ div } = React.DOM

SessionMixin = require("mixins/SessionMixin")

module.exports = React.createFactory React.createClass
  displayName: 'Search Filters'
  mixins: [SessionMixin]

  getInitialState: ->
    sortOptions: @getSortOptions()
    inputs:
      sort:
        val: @getSortValue()
      search:
        val: @getSearchQuery()
    errors: []
    searchError: false


  getSortOptions: ->
    return [] if !@props.sortOptions
    return @props.sortOptions

  
  getSortValue: ->
    if @getParameterByName("sort")
      return Number(@getParameterByName("sort"))

    return 0


  getSearchQuery: ->
    if @getParameterByName("query")
      return @getParameterByName("query")

    return ''


  handleSearchChange: (event) ->
    @inputs = @state.inputs
    @inputs.search.val = event.target.value

    @setState inputs: @inputs


  getErrorText: (key) ->
    for error in @state.errors
      if error.id == key
        return error.text
    
    return null


  search: ->
    @props.search(@state.inputs.search.val, @state.inputs.sort.val)

  
  handleChange: (event, index, value) ->
    @inputs = @state.inputs
    @inputs.sort.val = value
    @setState inputs: @inputs

  
  render: ->
    div { className: "sarch__filter" },
      "Search Filter:"

      React.createElement(Material.TextField,
        {
          id: "search-field",
          hintText: "Enter text to search for",
          floatingLabelText: "Search",
          fullWidth: true,
          value: @state.inputs.search.val,
          onChange: @handleSearchChange,
          errorText: @getErrorText("search")
        })
      if @state.sortOptions.length > 0
        React.createElement(Material.SelectField,
          { floatingLabelText: "Sort", value: @state.inputs.sort.val, onChange: @handleChange },
          @state.sortOptions.map (item, index) ->
            React.createElement(Material.MenuItem, {value: item.id, primaryText: item.title, key: "search-filter-item-#{index}"})
        )
      React.createElement(Material.RaisedButton, { label: "Search", onClick: @search })

