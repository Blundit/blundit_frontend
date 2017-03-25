{ div } = React.DOM

module.exports = React.createFactory React.createClass
  updateField: (event) ->
    return if !event? or !event.target?
    @props.updateField(event.target.id, event.target.value)


  getErrorText: (key) ->
    for error in @props.errors
      if error.id == key
        return error.text
    
    return null

  
  updateDate: (event, date) ->
    @props.updateField("prediction_date", date)


  render: ->
    div {},
      React.createElement(Material.TextField,
        {
          id: "title",
          hintText: "Prediction Title",
          floatingLabelText: "Title",
          multiLine: false,
          rows: 1,
          fullWidth: true,
          value: @props.prediction.title
          onChange: @updateField,
          errorText: @getErrorText("title")
        })
      React.createElement(Material.TextField,
        {
          id: "description",
          hintText: "Description",
          floatingLabelText: "Description",
          multiLine: true,
          rows: 2,
          fullWidth: true,
          rowsMax: 4,
          value: @props.prediction.description
          onChange: @updateField,
          errorText: @getErrorText("description")
        })
      React.createElement(Material.DatePicker,
        {
          hintText: "Prediction Date",
          value: @props.prediction.prediction_date,
          onChange: @updateDate
          errorText: @getErrorText("prediction_date")
        })
      if @getErrorText("prediction_date")?
        div {},
          @getErrorText("prediction_date")

      React.createElement(Material.TextField,
        {
          id: "url",
          hintText: "Evidence of Prediction (URL)",
          floatingLabelText: "Evidence",
          fullWidth: true,
          value: @props.prediction.url
          onChange: @updateField,
          errorText: @getErrorText("url")
        })
      "Pic Goes Here"