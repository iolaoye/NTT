# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

create_project = ->
  $("#div_new").toggle(true)

select_counties = ->
    $.getJSON "/states/" + $("#stateselect")[0].value + "/counties.json", (counties) ->
    items = []
    items.push "<option value>Select County</option>"
    $.each counties, (key, county) ->
      items.push "<option value=\"" + county.id + "\">" + county.county_name + "</option>"
    $("#countyselect").html items.join("")
    $("#countyselect").removeAttr("disabled")

select_rotations = ->
    $.getJSON "/states/" + $("#stateselect")[0].value + "/crop_schedules.json", (rotations) ->
    items = []
    items.push "<option value>Select Crop Rotation</option>"
    $.each rotations, (key, rotation) ->
      items.push "<option value=\"" + rotation.id + "\">" + rotation.name + "</option>"
    $("#rotationselect").html items.join("")
    $("#rotationselect").removeAttr("disabled")

$(document).ready ->
  $("#new_project").click ->
    create_project()
  $("#stateselect").change ->
    select_rotations
    select_counties
    