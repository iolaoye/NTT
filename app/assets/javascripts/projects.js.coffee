# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

create_project = ->
  $("#div_new").toggle(true)

get_counties = ->
    url = "/states/" + $("#state_select")[0].value + "/counties.json"
    $.getJSON url, (counties) ->
      items = []
      items.push "<option value>Select County</option>"
      $.each counties, (key, county) ->
        items.push "<option value=\"" + county.id + "\">" + county.county_name + "</option>"
      $("#county_select").html items.join("")
      $("#county_select").removeAttr("disabled")

get_rotations = ->
    $.getJSON "/states/" + $("#state_select")[0].value + "/crop_schedules.json", (rotations) ->
      items = []
      items.push "<option value>Select Crop Rotation</option>"
      $.each rotations, (key, rotation) ->
        items.push "<option value=\"" + rotation.id + "\">" + rotation.name + "</option>"
      $("#rotation_select").html items.join("")
      $("#rotation_select").removeAttr("disabled")

get_scp = ->
    $.getJSON "/bmpsublists.json", (bmps) ->
      items = []
      items.push "<option value>Select SCP</option>"
      $.each bmps, (key, bmp) ->
        items.push "<option value=\"" + bmp.id + "\">" + bmp.name + "</option>"
      $("#scp_select").html items.join("")
      $("#scp_select").removeAttr("disabled")

get_bmp = ->
    $.getJSON "/bmps/" + $("#scp_select")[0].value + ".json?county_id=" + $("#county_select")[0].value + "&rotation_id=" + $("#rotation_select")[0].value, (options) ->
      items = []
      items.push "<option value>Select SCP option</option>"
      $.each options, (key, option) ->
        items.push "<option value=\"" + option.id + "\">" + "Depth=" + option.depth + "(ft)" + "</option>"
      $("#option_select").html items.join("")
      $("#option_select").removeAttr("disabled")    
      $("#bmp").val("Depth = " + value.depth + " ft")

get_values = -> 
  statess = $("#state_select")[0].value;
  countiess = $("#county_select")[0].value;


$(document).ready ->
  $("#new_project").click ->
    create_project()
  $("#state_select").change ->
    get_counties()
  $("#county_select").change ->
    get_rotations() 
    get_values()
  $("#rotation_select").change ->
    get_scp()
  $("#scp_select").change ->
    get_bmp()
