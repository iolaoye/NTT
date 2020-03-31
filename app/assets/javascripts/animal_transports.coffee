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

get_trailer = (trailer_id) ->
    url = "/trailers/" + trailer_id + ".json"
    $.getJSON url, (trailer) ->
       $("#animal_transport_trailer_id").val(trailer.id)
       $("#code_trailer").val(trailer.code)
       $("#description_trailer").val(trailer.description)
    $("#pop-up_trailer").hide()

get_truck = (truck_id) ->
    url = "/trucks/" + truck_id + ".json"
    $.getJSON url, (truck) ->
       $("#animal_transport_truck_id").val(truck.id)
       $("#code_truck").val(truck.code)
       $("#description_truck").val(truck.description)
    $("#pop-up_truck").hide()

$(document).ready ->
    $("#animal_transport_categories_slaug").change ->
        hide_controls()
        display_control()

    $("input").click ->
        if this.id == "trailer"
            get_trailer(this.name)
        if this.id == "truck"
            get_truck(this.name)
