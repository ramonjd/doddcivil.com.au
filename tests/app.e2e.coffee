casper.test.begin 'Page setup', 2, suite = (test) ->
  
  casper.start 'http://localhost:3000', ->
    test.assertTitle 'Dodd Civil', 'Title OK'
    test.assertExists 'h1'
    return
  
  casper.run ->
    test.done()
    return

  return