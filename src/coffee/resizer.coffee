resizeTimer = null
resizeHandlers = []

resizeFunction = ()->
  for handler in resizeHandlers
    handler()
    
# set resize event
attachResize = ()->
  $(window).resize ()->
    clearTimeout resizeTimer
    resizeTimer = setTimeout resizeFunction, 250
  
class Resizer
  constructor: ()->
    throw new Error 'window.$ not found' if not window.$?
  register: (f)->
    resizeHandlers.push(f) if typeof f is 'function'
  listen: ()->
    # start listening
    attachResize()
    # fire once
    resizeFunction()
    
module.exports = Resizer