{ div, img, span } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
PredictionExpertCard = require("components/PredictionExpertCard")
Comments = require("components/Comments")
Votes = require("components/Votes")
AddToPrediction = require("components/AddToPrediction")
PredictionEvidences = require("components/PredictionEvidences")
BookmarkIndicator = require("components/BookmarkIndicator")
ImageUpload = require("components/ImageUpload")
LoadingBlock = require("components/LoadingBlock")

SessionMixin = require("mixins/SessionMixin")
LinksMixin = require("mixins/LinksMixin")
DateMixin = require("mixins/DateMixin")
AvatarMixin = require("mixins/AvatarMixin")

module.exports = React.createFactory React.createClass
  mixins: [SessionMixin, LinksMixin, DateMixin, AvatarMixin]
  displayName: 'Prediction'

  getInitialState: ->
    prediction: null
    experts: []
    loadError: null
    showCreated: @doShowCreated()
    voteSubmitted: null
    voteSubmitting: false
    user: null


  handleUserChange: (data) ->
    @setState user: UserStore.get()

    if @state.prediction == null
      @fetchPrediction()


  componentDidMount: ->
    UserStore.subscribe(@handleUserChange)

  
  componentWillUnmount: ->
    UserStore.unsubscribe(@handleUserChange)

  
  fetchPrediction: ->
    params = {
      path: "prediction"
      path_variables:
        prediction_id: @props.id
      success: @predictionSuccess
      error: @predictionError
    }
    API.call(params)

  
  predictionSuccess: (data) ->
    @setState prediction: data.prediction
    @setState experts: data.experts


  predictionError: (error) ->
    @setState loadError: error.responseJSON.errors

  
  updateBookmark: (data) ->
    @prediction = @state.prediction
    @prediction.bookmark = data
    @setState prediction: @prediction


  successCardStyle: ->
    return {
      backgroundColor: "#237a0b"
      color: "#ffffff"
      margin: 4
    }

  
  removeAlert: ->
    @setState showCreated: false

  
  doShowCreated: ->
    if @getParameterByName("created") == 1 or @getParameterByName("created") == "1"
      return true
    else
      return false

  
  showNewPredictionText: ->
    div { className: "prediction__created" },
      if @state.showCreated == true
        React.createElement(Material.Chip, {
          style: @successCardStyle(),
          onRequestDelete: @removeAlert
        },
          "Success! You've added a new prediction to the system. Now you can add more information to it!"
        )


  vote: (v) ->
    { prediction } = @state
    @setState voteSubmitting: true

    params = {
      path: "vote_for_prediction"
      path_variables:
        prediction_id: prediction.id
      data:
        value: v
      success: @voteSuccess
      error: @voteError
    }

    API.call(params)

  
  voteSuccess: (data) ->
    @setState voteSubmitting: false
    @setState voteSubmitted: true

  
  voteError: (error) ->
    @setState voteSubmitting: false
    @setState voteSubmitted: false

  
  categoryMaterialStyle: ->
    { margin: 4 }


  showAccuracy: (val) ->
    if val == null
      return "Unknown"
    else
      if val >= 0.5
        return "Correct"
      else
        return "Incorrect"

    
  showStatus: ->
    { prediction } = @state

    if prediction?
      if prediction.open == false
        return "Not Yet Open"
      else if prediction.open == true
        return "Open"
      else if prediction.status == 1
        return "Closed"

    else
      return "Unknown"

  
  predictionDescription: ->
    { prediction } = @state

    if prediction.description? and prediction.description > ''
      return prediction.description
    else
      return span { className: "not-found" }, "This prediction has no description."

  
  render: ->
    { prediction, experts } = @state
    div {},
      Header {}, ''
      div { className: "predictions-wrapper" },
        div { className: "predictions-content" },
          if !prediction?
            LoadingBlock
              title: "Prediction"
          if prediction?
            div { className: "prediction" },
              @showNewPredictionText()
              div { className: "default__card" },
                div { className: "text__title prediction__title" },
                  prediction.title
                div
                  className: "prediction__image"
                  style:
                    backgroundImage: "url(#{@getPredictionAvatar(prediction)})"
                  if UserStore.loggedIn()
                    ImageUpload
                      type: "prediction"
                      item_id: prediction.id
                      refresh: @fetchPrediction
                div { className: "prediction__meta" },
                  div { className: "prediction__meta-date" },
                    "This prediction will happen by #{@formatDate(prediction.prediction_date)}"
                  div { className: "prediction__meta-status" },
                    "This prediction is #{@showStatus()}"
                  div { className: "prediction__meta-description" },
                    @predictionDescription()
                  div { className: "not-found" },
                    "TODO: Add other fields here"
                if UserStore.loggedIn()
                  div { className: "prediction__meta-bookmark" },
                    BookmarkIndicator
                      bookmark: @state.prediction.bookmark
                      type: "prediction"
                      id: @state.prediction.id
                      updateBookmark: @updateBookmark
              div { className: "default__card prediction__categories" },
                div { className: "text__title" },
                  "Categories"
                div { className: "text__normal" },
                  "These are the categories this prediction is connected to:"
                if prediction.categories.length == 0
                  div { className: "not-found" },
                    "No categories yet."
                else
                  div {},
                    prediction.categories.map (category, index) =>
                      React.createElement( Material.Chip,
                        { onTouchTap: @goToCategory.bind(@, category.id), key: "prediction-category-chip-#{index}", style: @categoryMaterialStyle() },
                        category.name
                      )
              div { className: "default__card prediction__accuracy" },
                div { className: "text__title" },
                  "Accuracy"
                "This prediction is marked: #{@showAccuracy(prediction.vote_value)}"
              div { className: "default__card prediction__experts" },
                div { className: "text__title prediction__experts-name" },
                  "Experts"
                div { className: "prediction__experts-list" },
                  if experts.length > 0
                    experts.map (expert, index) ->
                      PredictionExpertCard
                        expert: expert
                        prediction: prediction
                        key: "prediction-expert-#{index}"
                  else
                    "No experts"
                if UserStore.loggedIn()
                  AddToPrediction
                    prediction: prediction
                    type: "prediction"
                    items: experts
                    refresh: @fetchPrediction
              PredictionEvidences
                evidences: prediction.evidences
                prediction: prediction
                refresh: @fetchPrediction
              Votes
                type: "prediction"
                item: prediction
                vote: @vote
                submitting: @state.voteSubmitting
                submitted: @state.voteSubmitted
              Comments
                type: "prediction"
                id: prediction.id
                item: prediction
                num: prediction.comments_count
          else
            div {},
              @state.loadError
      Footer {}, ''