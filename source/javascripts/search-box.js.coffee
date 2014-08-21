$ ->
  $('.navbar .search-input + .glyphicon').on 'mousedown', ->
    $this = $ this
    $input = $this.siblings('.search-input')
    setTimeout (-> $input.focus()), 0
    if $input.val().length > 0
      $this.closest('form').submit()
