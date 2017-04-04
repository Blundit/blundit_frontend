{ div } = React.DOM

module.exports = React.createFactory React.createClass
  render: ->
    div {},
      "You've successfully registered! You'll get a confirmation email shortly, which will allow you to log in and start Blunditing."
