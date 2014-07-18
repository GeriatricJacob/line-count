
window.initForms = ->
  $('.notice, .error').each -> $(@).height $(@).height()
  $('.notice, .error').click -> $(@).addClass 'hidden'

  $('.input input, .input textarea, .input select').focus -> $(@).parents('.input').addClass 'focus'
  $('.input input, .input textarea, .input select').blur -> $(@).parents('.input').removeClass 'focus'

  $('.input select').each -> $(@).wrap '<div class="select"/>'
  $('output[for]').each ->
    output = $(@)
    input = $("##{output.attr('for')}")
    input.on 'input', -> output.val input.val()
    output.val input.val()

  $('select:not(.date):not(.time):not(.datetime)').chosen(width: '100%')

  $('select[multiple]').parents('.select').addClass('multiple')
  # $('#input_long_multi_chosen').addClass('chosen-with-drop')

  $('input[type=file]').change (e) ->
    input = $(@)
    value = input.val()
    container = input.parents('.input')
    container.find('.label').removeClass('placeholder').text(value)

