{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
PredictionFields = require("components/PredictionFields")

module.exports = React.createFactory React.createClass
  displayName: "Create Prediction View"

  getInitialState: ->
    prediction:
      title: ''
      description: ''
      url: ''
      prediction_date: null
      pic: ''
      category: ''
    errors: []
    submitPredictionError: null
    submittingPrediction: false


  updateField: (id, val) ->
    @prediction = @state.prediction
    @prediction[id] = val

    @setState prediction: @prediction


  assemblePredictionData: ->
    return @state.prediction

  
  createPrediction: ->
    @setState submitPredictionError: null

    if @validateInputs()
      @setState submittingPrediction: true

      params = {
        path: "create_prediction"
        data:
          title: @state.prediction.title
          description: @state.prediction.description
          url: @state.prediction.url
          prediction_date: @state.prediction.prediction_date
          category: @state.prediction.category
        success: @createPredictionSuccess
        error: @createPredictionError
      }

      API.call(params)
  

  createPredictionError: (error) ->
    if error.responseJSON? and error.responseJSON.errors?
      @setState submitPredictionError: error.responseJSON.errors[0]
    else
      @setState submitPredictionError: "There was an error."

    @setState submittingPrediction: false

  
  createPredictionSuccess: (data) ->
    @setState submittingPrediction: false
    if data.prediction?
      navigate("/predictions/#{data.prediction.alias}?created=1")


  validateInputs: ->
    @errors = []
    if @state.prediction.title.length < 3
      @errors.push { id: "title", text: "Title must be at least 3 characters long." }

    if @state.prediction.prediction_date == null
      @errors.push { id: "prediction_date", text: "Date required for prediction." }

    if @state.prediction.category == ''
      @errors.push { id: "category", text: "Category is required." }
    
    @setState errors: @errors

    return true if @errors.length == 0
    return false


  render: ->
    div {},
      Header {}, ''
      div { className: "predictions-wrapper" },
        div { className: "predictions-content" },
          "Create Prediction"
          if UserStore.loggedIn()
            div {},
              PredictionFields
                prediction: @state.prediction
                errors: @state.errors
                updateField: @updateField

              if @state.submittingPrediction != true
                React.createElement(Material.RaisedButton, { label: "Create", onClick: @createPrediction })
              else
                @style = {
                  display: 'inline-block'
                  position: 'relative'
                  boxShadow: 'none'
                }
                React.createElement(Material.RefreshIndicator, { style: @style, size: 50, left: 0, top: 0, status:"loading" })
              if @state.submitPredictionError?
                div {},
                  @state.submitPredictionError

          else
            div {},
              "You must be logged in to add an prediction to the sytem."
      Footer {}, ''