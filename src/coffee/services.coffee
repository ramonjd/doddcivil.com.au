Services =
  $container: $('#services')
  loaded: false
  refresh: ()->
    if @loaded is false
      @loaded=true
      @$container.find('img').velocity 'transition.slideLeftIn',
        stagger : 150
    

module.exports = Services