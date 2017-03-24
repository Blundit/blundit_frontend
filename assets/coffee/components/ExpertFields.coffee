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


  render: ->
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
      React.createElement(Material.TextField,
        {
          id: "description",
          hintText: "Description",
          floatingLabelText: "Description",
          multiLine: true,
          rows: 2,
          fullWidth: true,
          rowsMax: 4,
          value: @props.expert.description
          onChange: @updateField,
          errorText: @getErrorText("description")
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