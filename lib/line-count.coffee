
fs   = require 'fs'
sloc = require 'sloc'
filewalker = require 'filewalker'

suffixes = [
  'coffee'
  'js'
  'c'
  'cc'
  'java'
  'php'
  'php5'
  'go'
  'css'
  'scss'
  'less'
  'py'
  'html'
]

pad = (num) ->
  num = '' + num
  while num.length < 4 then num = ' ' + num
  ' ' + num

addAttrs = (sfx, aIn, b) ->
  a = (aIn[sfx] ?= {})
  for k, v of b
    a[k] ?= 0
    a[k] += v


module.exports =

  activate: ->
    atom.workspaceView.command "line-count:open", => @open()

  open: ->
    text = ''
    add = (txt) -> text += (txt ? '') + '\n'

    atom.workspaceView.open('Line Count').then (editor) ->
      rootDirPath = atom.project.getRootDirectory().path

      files    = {}
      typeData = {}
      total    = {}

      filewalker(rootDirPath, maxPending: 4).on("file", (path, stats, absPath) ->

          sfxMatch = /\.([^\.]+)$/.exec path
          if sfxMatch and
              (sfx = sfxMatch[1]) in suffixes and
              path.indexOf('node_modules') is -1
            code = fs.readFileSync absPath, 'utf8'
            try
              counts = sloc code, sfx
            catch e
              add 'Warning: ' + e.message
              return

            files[path] = counts
            addAttrs sfx, typeData, counts
            addAttrs  '', total,    counts

        ).on("error", (err) ->
          add err.message

        ).on("done", ->
          add '\nCounts are in order of source, comments, and total.'
          add '\nFiles\n-----'
          for path, c of files
            add pad(c.sloc) + pad(c.cloc) + pad(c.loc) +  '  ' + path

          add '\nTypes\n-----'
          for type, c of typeData
            add pad(c.sloc) + pad(c.cloc) + pad(c.loc) + '  ' + type

          add '\nTotal\n-----'
          c = total['']
          add pad(c.sloc) + pad(c.cloc) + pad(c.loc)

          editor.setText text

        ).walk()
