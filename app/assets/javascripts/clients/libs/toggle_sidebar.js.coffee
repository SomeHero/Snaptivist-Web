# Toggle view of sidebar

toggle_sidebar = ->
  icon = $('#main-menu-toggle')
  sidebar = $('#sidebar-left')
  content = $('#content')
  logo = $('.brand')
  icon.bind 'click', ->
    console.log 'toggling sidebar'
    if icon.hasClass('open')
      icon.removeClass('open').addClass('close')
      sidebar.hide()
    else
      icon.removeClass('close').addClass('open')
      sidebar.show()

    content.toggleClass('full')
    logo.toggleClass('noBg')

enable_dropmenu = ->
  $('.dropmenu').bind 'click', (e) ->
    e.preventDefault()
    $(this).parent().find('ul').slideToggle()

$ ->
  toggle_sidebar()
  enable_dropmenu()