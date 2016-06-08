# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

select_scenarios = ->
    url = "/scenarios/" + $("#watershed_field_id").val() + "/list.json"
    $.getJSON url, (scenarios) ->
<<<<<<< HEAD
=======

>>>>>>> b2b77f74bb8113d39ff443fdf051cc57478c8667
       items = []
       items.push "<option value>Select Scenarios</option>"
       $.each scenarios, (key, scenario) ->
          items.push "<option value=\"" + scenario.id + "\">" + scenario.name + "</option>"
       $("#watershed_scenario_id").html items.join("")
       $("#watershed_scenario_id").removeAttr("disabled")
<<<<<<< HEAD
=======

      items = []
      items.push "<option value>Select Scenarios</option>"
      $.each scenarios, (key, scenario) ->
         items.push "<option value=\"" + scenario.id + "\">" + scenario.name + "</option>"
      $("#watershed_scenario_id").html items.join("")
      $("#watershed_scenario_id").removeAttr("disabled")

>>>>>>> b2b77f74bb8113d39ff443fdf051cc57478c8667

$(document).ready ->
    $("#watershed_field_id").change ->
       select_scenarios()