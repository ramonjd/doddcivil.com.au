# vendor
window.jQuery = window.$ = require '../js/jquery'
require '../js/jquery.touchSwipe'
require '../js/bootstrap'
require '../js/velocity'
require '../js/velocity.ui'

# modules
Resizer = require './resizer.coffee'

$ ()->
  $body = $ 'body'
  $nav = $ 'nav.navbar'
  $navBarToggle = $ '.navbar-toggle'
  $collapse = $ '.collapse'
  navOffset = null
  scrollOffset = null
  isTouch = Modernizr.touch
  clickEvent = if isTouch is true then 'touchstart' else 'click'
  
  # register resizer functions
  resizer = new Resizer
  resizer.register ->
    # get true height of navbar for scrollspy offset
    navOffset = $nav.outerHeight(true)
    # get offset amount for scroll animation
    scrollOffset = Math.floor $nav.height()
  resizer.listen()
  
  # toggle nav function - only fire if nav is open
  toggleNav = (displayStr)->
    if $navBarToggle.is ':visible'
      if displayStr is 'hide' and $collapse.hasClass 'in'
        $collapse.collapse displayStr
      else if displayStr is 'show'
        $collapse.collapse displayStr
        
  # set up scrollspy
  scrollspyOptions =
    target: '.main-nav-collapsable'
    offset: navOffset
  $body.scrollspy scrollspyOptions
  
  # scroll page onclick/touch
  $('.navbar-nav a').on clickEvent, (e)->
    e.preventDefault()
    toggleNav 'hide'
    goto = $(this).attr 'href'
    $(goto)
      .velocity 'scroll',
        duration: 250
        offset: -scrollOffset
        complete: ()->
          # abstract into new page controller module
          # only run once
          switch goto
            when '#services'
              $('#services img').velocity 'transition.slideLeftIn',
                stagger : 150
  # swipe down opens nav
  $nav.swipe
    swipeDown:()->
      toggleNav 'show'
      
      
# http://www.smashingmagazine.com/2014/06/18/faster-ui-animations-with-velocity-js/
# http://css-tricks.com/improving-ui-animation-workflow-velocity-js
# http://labs.rampinteractive.co.uk/touchSwipe/demos/