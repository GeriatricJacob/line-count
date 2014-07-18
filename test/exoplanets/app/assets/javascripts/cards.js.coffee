
window.initCards = ->
  $('.card .back').each ->

    $card = $(@).parents('.card')
    $toggle = $('<i class="icon-refresh"></i>')
    $toggle.click -> $card.toggleClass('flipped')
    $card.append $toggle
