{ div, a, span } = React.DOM

module.exports = React.createFactory React.createClass
  getInlineLinkImage: ->
    { item } = @props
    if item.pic?
      return "url(#{item.pic})"

    if item.image?
      return "url(#{item.image})"

    return "url()"


  getTitle: ->
    { item } = @props
    return item.title if item.title > ''
    return item.url if item.title == ''


  getDescription: ->
    { item } = @props

    if item.description?
      span {},
        item.description
    else
      span { className: "not-found" },
        "No description found."


  render: ->
    { item } = @props
    div
      className: "inline-link"
      div
        className: "inline-link__image"
        style:
          backgroundImage: @getInlineLinkImage()
      div { className: "inline-link__meta" },
        a
          className: "inline-link__meta-url"
          href: item.url
          target: "_blank"
          @getTitle()
        div { className: "inline-link__meta-description" },
          @getDescription()
