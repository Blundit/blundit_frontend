{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'Categories'

  getInitialState: ->
    categories: []


  componentDidMount: ->
    params: {
      path: "categories"
      success: @categoryListSuccess
      error: @categoryListError
    }
    API.call(params)


  categoryListSuccess: (data) ->
    @setState categories: data


  categoryListError: (error) ->
    console.log "error", error

  
  render: ->
    div {},
      Header {}, ''
      "Expert"
      Footer {}, ''