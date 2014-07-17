{View} = require 'atom'

module.exports =
class LineCountView extends View
  @content: ->
    editor      = atom.workspace.activePaneItem
    buffer      = editor.getBuffer()
    origRange   = editor.getSelection().getBufferRange()
    selText     = editor.getSelectedText().replace /[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&"

    if not selText then return

    origIdx = null
    matchArray = []
    buffer.scan new RegExp(selText, 'ig'), (res) ->
      if res.range.isEqual origRange
        origIdx = matchArray.length
      matchArray.push res

    if matchArray.length < 2 or origIdx is null then return

    if dir > 0
      if origIdx is matchArray.length - 1 then selMatchIdx = 0
      else selMatchIdx = origIdx + 1
    else
      if origIdx is 0 then selMatchIdx = matchArray.length - 1
      else selMatchIdx = origIdx - 1

    editor.setSelectedBufferRanges [matchArray[selMatchIdx].range]


    @div class: 'line-count overlay from-top', =>
      @div "The LineCount package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "line-count:toggle", => @toggle()

  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
