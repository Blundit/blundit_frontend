{ div } = React.DOM

Header = require("components/Header")
Footer = require("components/Footer")
ExpertCard = require("components/ExpertCard")

module.exports = React.createFactory React.createClass
  displayName: 'Experts'

  getInitialState: ->
    experts: null


  componentDidMount: ->
    params = {
      path: "experts"
      success: @expertListSuccess
      error: @expertListError
    }
    API.call(params)


  expertListSuccess: (data) ->
    @setState experts: data


  expertListError: (error) ->
    # console.log "error", error

  
  goToExpert: (id) ->
    navigate("/experts/#{id}")
  
  
  render: ->
    div {},
      Header {}, ''
      div { className: "experts-wrapper" },
        div { className: "experts-content" },
          div { className: "experts__list" },
            if @state.experts?
              @state.experts.map (expert, index) =>
                ExpertCard
                  expert: expert
                  key: "expert-card-#{index}"
                # div
                #   className: "experts__list__item"
                #   key: "expert-#{index}"
                #   onClick: @goToExpert.bind(@, expert.alias)
                #   expert.name

      Footer {}, ''