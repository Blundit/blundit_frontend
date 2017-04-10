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


  getCategoryDescription: (category) ->
    @class = "categories__list__item-description"
    @description = category.description

    if !category.description? or category.description == ""
      @class += "--not-found"
      @description = "Description not found. I'm sure one will be coming soon."

    div { className: @class },
      @description


  render: ->
    div {},
      Header {}, ''
      div { className: "categories-wrapper" },
        div { className: "categories-content" },
          div { className: "default__card categories__list" },
            div { className: "text__title" },
              "Categories"
            if @state.categories?
              @state.categories.map (category, index) =>
                div
                  className: "categories__list__item"
                  key: "category-#{index}"
                  onClick: @goToCategory.bind(@, category.id)
                  div { className: "categories__list__item-title"},
                    "#{category.name} (#{category.experts} E, #{category.predictions} P, #{category.claims} C)"
                  @getCategoryDescription(category)


      Footer {}, ''