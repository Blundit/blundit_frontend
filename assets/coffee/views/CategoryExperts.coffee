{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
CategoryExperts = require("components/CategoryExperts")
CategorySubHead = require("components/CategorySubHead")

module.exports = React.createFactory React.createClass
  displayName: 'Category - Experts'

  getInitialState: ->
    data: null
    category: null


  componentDidMount: ->
    @getCategoryAllInfo()
    @getCategoryInfo()


  getCategoryAllInfo: ->
    params = {
      path: "category_experts"
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
    @setState categories: data


  categoryAllError: (error) ->
    console.log "error", error


  categorySuccess: (data) ->
    @setState category: data


  categoryError: (error) ->
    console.log "error", error

  
  render: ->
    div {},
      Header {}, ''
        if @state.category
          div { className: "page-title" },
            "Category '#{@state.category.name}' - Showing Experts"
            CategorySubHead
              category_id: @props.id

        if @state.categories?
          div { className: "categories" },
            CategoryExperts
              experts: @state.data
      Footer {}, ''