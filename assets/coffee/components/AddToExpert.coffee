{ div } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'AddToExpert'

  getInitialState: ->
    showItems: false
    items: null
    category: null
    categories: null
    categoriesError: false


  componentDidMount: ->
    params = {
      path: "categories"
      success: @categoriesSuccess
      error: @categoriesError
    }


  categoriesSuccess: (data) ->
    @setState categories: data

  
  categoriesError: (error) ->
    @setState categoriesError: true


  addItem: ->
    # console.log


  handleChange: (event, index, value) ->
    @setState category: value


  doShowItems: ->
    @setState showItems: true


  render: ->
    div { className: "add-to-expert" },
      if @state.showItems == false
        div
          className: "add-to-expert__button"
          onClick: @doShowItems
          "Add #{@props.type} to Expert"
      else
        if @state.categories?
          div {},
            React.createElement(Material.SelectField,
              { floatingLabelText: "Category", value: @state.category, onChange: @handleChange },
              @state.categories.map (category, index) ->
                React.createElement(Material.MenuItem, {value: category.id, primaryText: category.name, key: "add-to-expert-category-#{index}"})
            )
            div
              className: "add-to-expert__button"
              onClick: @addItem
              'Add'



