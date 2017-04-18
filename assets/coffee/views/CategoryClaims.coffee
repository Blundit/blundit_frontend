{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
CategoryClaims = require("components/CategoryClaims")
CategorySubHead = require("components/CategorySubHead")
LoadingBlock = require("components/LoadingBlock")

module.exports = React.createFactory React.createClass
  displayName: 'Category - Claims'

  getInitialState: ->
    data: null
    category: null


  componentDidMount: ->
    @getCategoryAllInfo()
    @getCategoryInfo()


  getCategoryAllInfo: ->
    params = {
      path: "category_claims"
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
    { category, data } = @state
    div {},
      Header {}, ''
      div { className: "categories-wrapper" },
        div { className: "categories-content" },
          if !category? or !data?
            LoadingBlock
              text: "Category - Showing Claims"
          else
            div {},
              if category?
                div { className: "default__card" },
                  div { className: "text__title" },
                    "Category '#{category.name}' - Showing Claims"
                  CategorySubHead
                    category_id: @props.id

              if data?
                div { className: "default__card ategories" },
                  CategoryClaims
                    claims: data
      Footer {}, ''