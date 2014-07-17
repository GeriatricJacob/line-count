###
 asd
###

{View} = require 'atom'

module.exports =
class LineCountView extends View
  @content: ->
    editor     = atom.workspace.activePaneItem
    buffer     = editor.getBuffer()

    inComment = no
    totalCount = commentCount = 0
    buffer.scan /^.*$/g, (res) ->
      totalCount++
      text = buffer.getTextInRange res.range

      if not text or /^\s*#/.test text then commentCount++; return

      if (matches = /(\S*).*###.*(\S*).*(###)?.*(\S*)$/.exec text)
        if not inComment
          if not matches[3]
            if not matches[1] then commentCount++
            inComment = yes
          else
            if not matches[2] then commentCount++
        else
          if not matches[3]
            if not matches[2] and not matches[4] then commentCount++
          else
            if not matches[2] then commentCount++
          inComment = matches[3]

      console.log {totalCount, commentCount}

    @div class: 'line-count overlay from-top', =>
      @div "The LineCount package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "line-count:toggle", => @toggle()

  toggle: ->
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
