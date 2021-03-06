{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ExpertFields = require("components/ExpertFields")

module.exports = React.createFactory React.createClass
  displayName: "Create Expert View"

  getInitialState: ->
    expert:
      name: ''
      email: ''
      description: ''
      twitter: ''
      facebook: ''
      instagram: ''
      youtube: ''
      city: ''
      country: ''
      wikipedia: ''
      occupation: ''
      website: ''
      tag_list: ''
      avatar: ''
      category: ''
    errors: []
    submitExpertError: null
    submittingExpert: false


  updateField: (id, val) ->
    @expert = @state.expert
    @expert[id] = val

    @setState expert: @expert


  assembleExpertData: ->
    return @state.expert

  
  createExpert: ->
    @setState submitExpertError: null

    if @validateInputs()
      @setState submittingExpert: true

      params = {
        path: "create_expert"
        data:
          name: @state.expert.name
          description: @state.expert.description
          twitter: @state.expert.twitter
          facebook: @state.expert.facebook
          instagram: @state.expert.instagram
          youtube: @state.expert.youtube
          city: @state.expert.city
          country: @state.expert.country
          occupation: @state.expert.occupation
          website: @state.expert.website
          wikipedia: @state.expert.wikipedia
          tag_list: @state.expert.tag_list
          category: @state.expert.category
        success: @createExpertSuccess
        error: @createExpertError
      }

      API.call(params)
  

  createExpertError: (error) ->
    if error.responseJSON? and error.responseJSON.errors?
      @setState submitExpertError: error.responseJSON.errors[0]
    else
      @setState submitExpertError: "There was an error."

    @setState submittingExpert: false

  
  createExpertSuccess: (data) ->
    @setState submittingExpert: false
    if data.expert?
      navigate("/experts/#{data.expert.alias}?created=1")


  validateInputs: ->
    @errors = []
    if @state.expert.name.length < 3
      @errors.push { id: "name", text: "Name must be at least 3 characters long." }

    if @state.expert.category == ''
      @errors.push { id: "category", text: "Category is required." }
    

    @setState errors: @errors

    return true if @errors.length == 0
    return false


  render: ->
    div {},
      Header {}, ''
      div { className: "experts-wrapper" },
        div { className: "experts-content" },
          div { className: "default__card" },
            div { className: "text__title" },
              "Create Expert"
            if UserStore.loggedIn()
              div {},
                ExpertFields
                  expert: @state.expert
                  errors: @state.errors
                  updateField: @updateField

                if @state.submittingExpert != true
                  React.createElement(Material.RaisedButton, { label: "Create", onClick: @createExpert })
                else
                  @style = {
                    display: 'inline-block'
                    position: 'relative'
                    boxShadow: 'none'
                  }
                  React.createElement(Material.RefreshIndicator, { style: @style, size: 50, left: 0, top: 0, status:"loading" })
                if @state.submitExpertError?
                  div {},
                    @state.submitExpertError

            else
              div { className: "not-found" },
                "You must be logged in to add an expert to the sytem."
      Footer {}, ''