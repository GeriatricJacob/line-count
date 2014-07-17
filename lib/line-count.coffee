LineCountView = require './line-count-view'

module.exports =
  lineCountView: null

  activate: (state) ->
    @lineCountView = new LineCountView(state.lineCountViewState)

  deactivate: ->
    @lineCountView.destroy()

  serialize: ->
    lineCountViewState: @lineCountView.serialize()
