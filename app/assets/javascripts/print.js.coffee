# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  event_type = if $(".alert-success").length > 0
    'Print Success'
  else if $(".alert-danger").length > 0
    'Print Error'
  else
    'Page View'

  #mixpanel.track(event_type)

  # if !defaults && (p = $.cookie("printer")) && (b = $.cookie("building"))
  #   building.select2("val", b)
  #   change_printers(b)
  #   printer.select2("val", p)
