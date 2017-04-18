{ div } = React.DOM

module.exports = React.createFactory React.createClass
  loadingClass: ->
    { type } = @props
    @class = "loading"

    if type == "short"
      @class += "--short"

    return @class


  render: ->
    { type, dataType, title } = @props
    dataType = "data" if !type?
    title = "Loading" if !title?


    div { className: @loadingClass() },
      div { className: "text__title" },
        title
      div { className: "not-found" },
        "This data is currently being loaded. Please hold..."
      div { className: "loading__progress" },
        React.createElement(Material.LinearProgress, { mode: "indeterminate" })