{ div, span, input } = React.DOM

module.exports = React.createFactory React.createClass
  getInitialState: ->
    showImageEdit: false
    imageSubmitting: false
    imageError: null
    imageSuccess: null


  cancelImage: ->
    @setState showImageEdit: false
    @setState showImageDelete: false
    @setState imageSubmitting: true

  
  showImageDelete: ->
    @setState showImageEdit: false
    @setState showImageDelete: true
    @setState imageSubmitting: false

  
  showImageEdit: ->
    @setState showImageEdit: true
    @setState showImageDelete: false
    @setState imageSubmitting: false


  removeImage: ->
    if @props.type == "expert"
      params = {
        path: "delete_expert_image"
        path_variables:
          expert_id: @props.item_id
        success: @updateImageSuccess
        error: @updateImageError
      }
    else if @props.type == "claim"
      params = {
        path: "delete_claim_image"
        path_variables:
          claim_id: @props.item_id
        success: @updateImageSuccess
        error: @updateImageError
      }
    else if @props.type == "prediction"
      params = {
        path: "delete_prediction_image"
        path_variables:
          prediction_id: @props.item_id
        success: @updateImageSuccess
        error: @updateImageError
      }

    API.call(params)

  
  submitImageEdit: ->
    image = document.getElementById("item__image")

    if image.files? and image.files[0]?
      @setState imageSubmitting: true
      @setState imageSuccess: null
      @setState imageError: null

      @formData = new FormData()

      if @props.type == "expert"
        @formData.append("avatar", image.files[0])

        params = {
          path: "update_expert_image"
          path_variables:
            expert_id: @props.item_id
          data: @formData
          success: @updateImageSuccess
          error: @updateImageError
        }
      else if @props.type == "claim"
        @formData.append("pic", image.files[0])

        params = {
          path: "update_claim_image"
          path_variables:
            claim_id: @props.item_id
          data: @formData
          success: @updateImageSuccess
          error: @updateImageError
        }

      else if @props.type == "prediction"
        @formData.append("pic", image.files[0])

        params = {
          path: "update_prediction_image"
          path_variables:
            prediction_id: @props.item_id
          data: @formData
          success: @updateImageSuccess
          error: @updateImageError
        }

      API.call(params)

  
  updateImageSuccess: (data) ->
    @setState omageSubmitting: false
    @setState imageSuccess: "#{@props.type} Updated!"
    @cancelImage()

    @props.refresh()
    
  
  updateImageError: (error) ->
    @setState imageSubmitting: false
    if error.responseJSON? and error.responseJSON.errors?
      @setState imageError: error.responseJSON.errors[0]
    else
      @setState imageError: "There was an error."



  
  render: ->
    div { className: "avatar__chrome" },
      span
        className: "avatar__chrome__delete-button"
        onClick: @showImageDelete
        span { className: "fa fa-close" }, ''
      span
        className: "avatar__chrome__edit-button"
        onClick: @showImageEdit
        span { className: "fa fa-pencil"}, ''

      if @state.showImageEdit == true
        div { className: "avatar__chrome__edit" },
          if @state.imageSubmitting == true
            div { className: "avatar__chrome__image--submitting" },
              "Uploading Image..."
          else
            input
              className: "item__image"
              type: "file"
              id: "item__image"
              accept: ".png,.jpeg,.jpg,.gif"
              onChange: @submitImageEdit
          React.createElement(Material.RaisedButton, {label: "Cancel", primary: true, onClick: @cancelImage })
      if @state.showImageDelete == true
        div { className: "avatar__chrome__delete" },
          React.createElement(Material.RaisedButton, {label: "Remove Image", primary: true, onClick: @removeImage })
          React.createElement(Material.RaisedButton, {label: "Cancel", primary: true, onClick: @cancelImage })
                          