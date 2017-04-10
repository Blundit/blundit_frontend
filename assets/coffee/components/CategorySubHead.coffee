{ div } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: "Category Filter Subhead"

  showAll: ->
    navigate("/categories/#{@props.category_id}")


  showExperts: ->
    navigate("/categories/#{@props.category_id}/experts")

  
  showClaims: ->
    navigate("/categories/#{@props.category_id}/claims")


  showPredictions: ->
    navigate("/categories/#{@props.category_id}/predictions")


  currentPage: (id) ->
    @path = window.location.pathname
    if id == ''
      if @path.indexOf("/#{@props.category_id}/") == -1
        return true
      else
        return false
    else
      if @path.indexOf("/#{@props.category_id}/#{id}") == -1
        return false
      else
        return true


  goBack: ->
    navigate("/categories")


  render: ->
    div { className: "page-subhead" },
      div
        className: "page-subhead__back"
        onClick: @goBack
        '<<'
      if @currentPage('')
        div
          className: "page-subhead__item--active"
          'All'
      else
        div
          className: "page-subhead__item"
          onClick: @showAll
          'All'

      if @currentPage('experts')
        div
          className: "page-subhead__item--active"
          'Experts'
      else
        div
          className: "page-subhead__item"
          onClick: @showExperts
          'Experts'

      if @currentPage('predictions')
        div
          className: "page-subhead__item--active"
          'Predictions'
      else
        div
          className: "page-subhead__item"
          onClick: @showPredictions
          'Predictions'
      
      if @currentPage('claims')
        div
          className: "page-subhead__item--active"
          'Claims'
      else
        div
          className: "page-subhead__item"
          onClick: @showClaims
          'Claims'