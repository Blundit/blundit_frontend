{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ExpertFields = require("components/ExpertFields")

module.exports = React.createFactory React.createClass
  displayName: "Create Expert View"

  getInitialState: ->
    expert: {}


  render: ->
    div {},
      Header {}, ''
      div { className: "expert-wrapper" },
        div { className: "expert-content" },
          "Create Expert"
          ExpertFields
            expert: @state.expert
      Footer {}, ''