# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

display_control = ->
    for i in [1..$("#animal_transport_categories_trans").val()]
        $("#tdweight" + i).toggle(true)
        $("#tdweight" + i)[0].style.display = ""

$(document).ready ->
    $("#animal_transport_categories_trans").change ->
        display_control()