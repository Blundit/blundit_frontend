{ div, a } = React.DOM

module.exports = React.createFactory React.createClass
  displayName: 'SocialShare'

  facebookTitle: ->
    return "Blundit - The world's best expert tracker"

  
  facebookIcon: ->
    return 'http://blundit.com/images/blundit_logo.png'

    
  getSharingText: ->
    if @props.type == "expert"
      @title = @props.item.name
    else
      @title = "'#{@props.item.title}'"

    return "Find out how accurate #{@title} is on Blundit, the world's best expert tracker."

  
  facebookShare: ->
    @url = 'http://www.facebook.com/sharer.php?u='+@getSharingUrl()+'&description='+@getSharingText()
    @url += '&picture='+@facebookIcon()
    @url += '&title='+@facebookTitle()

    window.open @url, '_blank'


  getSharingUrl: ->
    return window.location.href


  render: ->
    div { className: "default__card social-share" },
      div { className: "text__title" },
        "Share"
      div { className: "social-share__links" },
        a
          onClick: @facebookShare
          target: '_blank'
          className: 'social-share__links-facebook fa fa-facebook'
          ''
        a
          href: 'http://www.twitter.com/share?url='+@getSharingUrl()+'&text='+@getSharingText()
          target: '_blank'
          className: 'social-share__links-twitter fa fa-twitter'
          ''
