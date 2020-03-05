# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
hide_controls = ->
    for i in [1..10]
        $("#weight" + i)[0].style.display = "none"
        $("#animals" + i)[0].style.display = "none"

display_control = ->
    for i in [1..$("#animal_transport_categories_slaug").val()]
        $("#weight" + i)[0].style.display = "inline"
        $("#animals" + i)[0].style.display = "inline"

$(document).ready ->
    $("#animal_transport_categories_slaug").change ->
        hide_controls()
        display_control()