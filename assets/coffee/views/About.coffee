{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")

module.exports = React.createFactory React.createClass
  displayName: 'About'
  
  render: ->
    div {},
      Header {}, ''
      div { className: "about-wrapper" },
        div { className: "about-content" },
          div { className: "default__card" },
            div { className: "text__title expert__name" },
              "About"
            div { className: "text__normal" },
              "Blundit is an expert tracker. It is THE expert tracker. It's semi-usable right now but still in development, and while this about page is skeletal now, all sorts of good stuff about the site will go here."
      Footer {}, ''