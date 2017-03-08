{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

CategoryPredictions = require("components/CategoryPredictions")
CategorySubHead = require("components/CategorySubHead")

module.exports = React.createFactory React.createClass
  displayName: 'Category - Predictions'

  getInitialState: ->
    data: null
    category: null


  componentDidMount: ->
    @getCategoryAllInfo()
    @getCategoryInfo()


  getCategoryAllInfo: ->
    params = {
      path: "category_predictions"
      path_variables:
        category_id: @props.id
      success: @categoryAllSuccess
      error: @categoryAllError
    }
    API.call(params)

  
  getCategoryInfo: ->
    params = {
      path: "category"
      path_variables:
        category_id: @props.id
      success: @categorySuccess
      error: @categoryError
    }
    API.call(params)

    
  categoryAllSuccess: (data) ->
    @setState data: data


  categoryAllError: (error) ->
    # console.log "error", error


  categorySuccess: (data) ->
    @setState category: data


  categoryError: (error) ->
    # console.log "error", error

  
  render: ->
    div {},
      Header {}, ''
      div { className: "categories-wrapper" },
        div { className: "categories-content" },
          if @state.category
            div { className: "page-title" },
              "Category '#{@state.category.name}' - Showing Experts, Claims and Predictions"
              CategorySubHead
                category_id: @props.id

          if @state.data?
            div { className: "categories" },
              CategoryPredictions
                predictions: @state.data
      Footer {}, ''