describe 'main', ->
  
  it 'should require jquery', ->
    expect($).toBeDefined()

  it 'should require Modernizr', ->
    expect(Modernizr).toBeDefined()