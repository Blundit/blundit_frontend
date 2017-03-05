{ div } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: "Category Filter Subhead"

  showAll: ->
    navigate("/categories/#{@props.category_id}/all")


  showExperts: ->
    navigate("/categories/#{@props.category_id}/experts")

  
  showClaims: ->
    navigate("/categories/#{@props.category_id}/claims")


  showPredictions: ->
    navigate("/categories/#{@props.category_id}/predictions")


  currentPage: (id) ->
    @path = window.location.pathname
    if id == ''
      if @path.indexOf "/#{@props.category_id}/" == -1
        return true
      else
        return false
    else
      if @path.indexOf "/#{@props.category_id}/#{id}" == -1
        return false
      else
        return true


  render: ->
    div { className: "page-subhead" },
      if @currentPage('')
        div
          className: "page-subhead__item"
          onClick: @showAll
          'All'
      else
        div
          className: "page-subhead__item--active"
          'All'

      if @currentPage('experts')
        div
          className: "page-subhead__item"
          onClick: @showExperts
          'Experts'
      else
        div
          className: "page-subhead__item--active"
          'Experts'
      if @currentPage('predictions')
        div
          className: "page-subhead__item"
          onClick: @showPredictions
          'Predictions'
      else
        div
          className: "page-subhead__item--active"
          'Predictions'
      
      if @currentPage('claims')
        div
          className: "page-subhead__item"
          onClick: @showClaims
          'Claims'
      else
        div
          className: "page-subhead__item--active"
          'Claims'