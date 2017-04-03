{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

LinksMixin = require("mixins/LinksMixin")

module.exports = React.createFactory React.createClass
  displayName: 'Categories'
  mixins: [LinksMixin]

  getInitialState: ->
    categories: null


  componentDidMount: ->
    params = {
      path: "categories"
      success: @categoryListSuccess
      error: @categoryListError
    }
    API.call(params)


  categoryListSuccess: (data) ->
    @setState categories: data


  categoryListError: (error) ->
    #console.log "error", error


  render: ->
    div {},
      Header {}, ''
      div { className: "categories-wrapper" },
        div { className: "categories-content" },
          div { className: "categories__list" },
            if @state.categories?
              @state.categories.map (category, index) =>
                div
                  className: "categories__list__item"
                  key: "category-#{index}"
                  onClick: @goToCategory.bind(@, category.id)
                  category.name


      Footer {}, ''