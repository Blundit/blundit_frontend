{ div } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'AddToExpert'

  getInitialState: ->
    showItems: false
    items: null
    item: null
    itemList: null
    itemsError: false


  componentDidMount: ->
    params = {
      path: "all_#{@props.type}s"
      success: @itemsSuccess
      error: @itemsError
    }

    API.call(params)


  itemsSuccess: (data) ->
    # prune items that the user already has
    @items = []

    for newItem in data
      @found = false
      for existingItem in @props.items
        if Number(newItem.id) == Number(existingItem.id)
          @found = true

      if @found == false
        @items.push newItem


    @setState itemList: @items

  
  itemsError: (error) ->
    @setState itemsError: true


  addItem: ->
    @setState error: null
    if @state.item == null
      @setState error: "Selection required"
      return

    params = {
      path: "add_#{@props.type}_to_expert"
      path_variables:
        expert_id: @props.expert.id
      data:
        id: @state.item
      success: @addSuccess
      error: @addError
    }

    API.call(params)


  addSuccess: (data) ->
    @props.refresh()


  addError: (error) ->
    @setState error: "Error adding #{@sentenceCase(@props.type)}"
    


  handleChange: (event, index, value) ->
    @setState item: value


  doShowItems: ->
    @setState showItems: true


  cancelAddItem: ->
    @setState item: null
    @setState showItems: false


  sentenceCase: (text) ->
    # TODO: Add this to universal mixin/class
    return text.replace(/\w\S*/g,
      (text) ->
        return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase()
    )


  render: ->
    div { className: "add-to-expert" },
      if @state.showItems == false
        div
          className: "add-to-expert__button"
          onClick: @doShowItems
          "Add #{@props.type} to Expert"
      else
        if @state.itemList?
          div {},
            React.createElement(Material.SelectField,
              { floatingLabelText: @sentenceCase(@props.type), value: @state.item, onChange: @handleChange },
              @state.itemList.map (item, index) ->
                React.createElement(Material.MenuItem, {value: item.id, primaryText: item.title, key: "add-to-expert-item-#{index}"})
            )
            React.createElement(Material.FlatButton, { label: "Add", onClick: @addItem })
            React.createElement(Material.FlatButton, { label: "Cancel", onClick: @cancelAddItem })
            if @state.error?
              div {},
                @state.error



