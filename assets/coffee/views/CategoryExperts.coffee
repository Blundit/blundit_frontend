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
          if @state.category?
            div { className: "default__card" },
              div { className: "text__title" },
                "Category '#{@state.category.name}' - Showing Experts"
              CategorySubHead
                category_id: @props.id
          else
            div { className: "default__card" },
              div { className: "not-found" },
                "Loading..."

          if @state.data?
            div { className: "default__card categories" },
              CategoryExperts
                experts: @state.data
      Footer {}, ''