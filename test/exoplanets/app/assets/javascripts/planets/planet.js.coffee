
class ex.Planet
  constructor: (@id=0, @rotation = 0, @rotationSpeed=20) ->
    @orbitables = []

  build: ->
    @node = document.createElement 'div'
    @body = document.createElement 'div'
    @node.appendChild @body
    @node.className = 'planet'
    @body.className = 'body'

    @body.setAttribute 'style', "background: url(images/#{@id}.png);"
    @node

  animate: (t) ->

    @lastTime = t if not @lastTime? or t - @lastTime > 1000
    @body.style.backgroundPosition = "#{@rotation}px 0"

    dif = (t - @lastTime) / 1000

    @rotation += @rotationSpeed * dif

    @orbitables.forEach (orbitable) -> orbitable.animate(dif)
    @lastTime = t

  addOrbitable: (orbitable) ->
    @orbitables.push orbitable unless orbitable in @orbitables
    @node.appendChild orbitable.node
    @node.appendChild orbitable.shadowNode

