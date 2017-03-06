{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
CategoryExperts = require("components/CategoryExperts")
CategoryClaims = require("components/CategoryClaims")
CategoryPredictions = require("components/CategoryPredictions")
CategorySubHead = require("components/CategorySubHead")

module.exports = React.createFactory React.createClass
  displayName: 'Categories'

  getInitialState: ->
    data: null
    category: null


  componentDidMount: ->
    @getCategoryAllInfo()
    @getCategoryInfo()


  getCategoryAllInfo: ->
    params = {
      path: "category_all"
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
    console.log "error", error


  categorySuccess: (data) ->
    @setState category: data


  categoryError: (error) ->
    console.log "error", error

  
  render: ->
    div {},
      Header {}, ''
        if @state.category?
          div { className: "page-title" },
            "Category '#{@state.category.name}' - Showing Experts, Claims and Predictions"
            CategorySubHead
              category_id: @props.id
        else
          div {},
            "Loading..."

        if @state.data?
          div { className: "categories" },
            CategoryExperts
              experts: @state.data.experts
            CategoryPredictions
              predictions: @state.data.predictions
            CategoryClaims
              claims: @state.data.claims
      Footer {}, ''