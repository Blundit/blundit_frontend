{ div } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'Expert Fields'

  getInitialState: ->
    categories: null


  componentDidMount: ->
    params = {
      path: "categories"
      success: @categoryListSuccess
      error: @categoryListError
    }
    API.call(params)


  categoryListSuccess: (data) ->
    @setState categories: data


  categoryListError: (error) ->
    #console.log "error", error


  updateField: (event) ->
    return if !event? or !event.target?
    @props.updateField(event.target.id, event.target.value)

  
  handleCategoryChange: (event, index, value) ->
    @props.updateField("category", value)


  getErrorText: (key) ->
    for error in @props.errors
      if error.id == key
        return error.text
    
    return null


  render: ->
    if @state.categories == null
      return div {}, 'Loading...'
    div {},

      React.createElement(Material.TextField,
        {
          id: "name",
          hintText: "Expert Name",
          floatingLabelText: "Name",
          multiLine: false,
          rows: 1,
          fullWidth: true,
          value: @props.expert.name
          onChange: @updateField,
          errorText: @getErrorText("name")
        })
      React.createElement(Material.SelectField,
        { floatingLabelText: "Category", value: @props.expert.category, onChange: @handleCategoryChange },
        @state.categories.map (item, index) ->
          React.createElement(Material.MenuItem, {value: item.id, primaryText: item.name, key: "expert-category-item-#{index}"})
      )
      if @getErrorText("category")
        div {},
          @getErrorText("category")
      React.createElement(Material.TextField,
        {
          id: "description",
          hintText: "Description",
          floatingLabelText: "Description",
          multiLine: true,
          fullWidth: true,
          rowsMax: 4,
          value: @props.expert.description
          onChange: @updateField,
          errorText: @getErrorText("description")
        })
      React.createElement(Material.TextField,
        {
          id: "occupation",
          hintText: "Occupation",
          floatingLabelText: "Occupation",
          fullWidth: true,
          value: @props.expert.occupation
          onChange: @updateField,
          errorText: @getErrorText("occupation")
        })
      React.createElement(Material.TextField,
        {
          id: "website",
          hintText: "Website",
          floatingLabelText: "Website",
          fullWidth: true,
          value: @props.expert.website
          onChange: @updateField,
          errorText: @getErrorText("website")
        })
      React.createElement(Material.TextField,
        {
          id: "city",
          hintText: "City",
          floatingLabelText: "City",
          fullWidth: true,
          value: @props.expert.city
          onChange: @updateField,
          errorText: @getErrorText("city")
        })
      React.createElement(Material.TextField,
        {
          id: "country",
          hintText: "Country",
          floatingLabelText: "Country",
          fullWidth: true,
          value: @props.expert.country
          onChange: @updateField,
          errorText: @getErrorText("country")
        })
      React.createElement(Material.TextField,
        {
          id: "email",
          hintText: "Email",
          floatingLabelText: "Email",
          fullWidth: true,
          value: @props.expert.email
          onChange: @updateField,
          errorText: @getErrorText("email")
        })
      React.createElement(Material.TextField,
        {
          id: "twitter",
          hintText: "Twitter Handle",
          floatingLabelText: "Twitter Handle",
          value: @props.expert.twitter
          onChange: @updateField,
          errorText: @getErrorText("twitter")
        })
      React.createElement(Material.TextField,
        {
          id: "facebook",
          hintText: "Facebook",
          floatingLabelText: "Facebook",
          value: @props.expert.facebook
          onChange: @updateField,
          errorText: @getErrorText("facebook")
        })
      React.createElement(Material.TextField,
        {
          id: "instagram",
          hintText: "Instagram Handle",
          floatingLabelText: "Instagram",
          value: @props.expert.instagram
          onChange: @updateField,
          errorText: @getErrorText("instagram")
        })
      React.createElement(Material.TextField,
        {
          id: "youtube",
          hintText: "Youtube",
          floatingLabelText: "Youtube",
          value: @props.expert.youtube
          onChange: @updateField,
          errorText: @getErrorText("youtube")
        })
      React.createElement(Material.TextField,
        {
          id: "tag_list",
          hintText: "Tags",
          floatingLabelText: "Tags",
          value: @props.expert.tag_list
          onChange: @updateField,
          errorText: @getErrorText("tag_list")
        })
        "Avatar Goes Here"