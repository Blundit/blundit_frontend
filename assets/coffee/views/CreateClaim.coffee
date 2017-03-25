{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ClaimFields = require("components/ClaimFields")

module.exports = React.createFactory React.createClass
  displayName: "Create Claim View"

  getInitialState: ->
    claim: {}


  render: ->
    div {},
      Header {}, ''
      div { className: "claims-wrapper" },
        div { className: "claims-content" },
          "Create Claim"
          ClaimFields
            claim: @state.claim
      Footer {}, ''