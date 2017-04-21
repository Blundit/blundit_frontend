{ div } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'AddToPrediction'

  getInitialState: ->
    showItems: false
    items: null
    item: null
    itemList: null
    itemsError: false
    evidenceOfBeliefUrl: ''


  componentDidMount: ->
    params = {
      path: "all_experts"
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
      path: "add_expert_to_prediction"
      path_variables:
        prediction_id: @props.prediction.id
      data:
        id: @state.item
      success: @addSuccess
      error: @addError
    }

    API.call(params)


  addSuccess: (data) ->
    @cancelAddItem()
    @props.refresh()


  addError: (error) ->
    @setState error: "Error adding Expert"
    

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
    div { className: "add-to-prediction" },
      if @state.showItems == false
        React.createElement(Material.RaisedButton, { label: "Add Expert to Prediction", onClick: @doShowItems })
      else
        if @state.itemList?
          div {},
            React.createElement(Material.SelectField,
              { floatingLabelText: "Expert", value: @state.item, onChange: @handleChange },
              @state.itemList.map (item, index) ->
                React.createElement(Material.MenuItem, {value: item.id, primaryText: item.title, key: "add-to-prediction-item-#{index}"})
            )
            React.createElement(Material.FlatButton, { label: "Add", onClick: @addItem })
            React.createElement(Material.FlatButton, { label: "Cancel", onClick: @cancelAddItem })
            if @state.error?
              div {},
                @state.error