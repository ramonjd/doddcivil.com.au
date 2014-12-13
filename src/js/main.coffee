$ ()->
  $body = $ 'body'
  scrollspyOptions =
    target: '.main-nav-collapsable'
    offset: 100
  #http://stackoverflow.com/questions/17879846/boostrap-scrollspy-offset-on-a-fixed-navbar-does-not-work
  $body.scrollspy scrollspyOptions
  $('.navbar-nav a').click (e)->
    e.preventDefault()
    goto = $(this).attr 'href'
    $(goto)[0].scrollIntoView()
    scrollBy(0, -100);
    
    #scrollOptions =
      #scrollTop: $(goto).offset().top
    #$('html, body').animate scrollOptions, 250