// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

updateCounties = ->
  $.getJSON "/states/" + $("#location_state_id").val() + "/counties.json", (counties) ->
    items = []
    items.push "<option value>Select County</option>"
    $.each counties, (key, county) ->
      items.push "<option value=\"" + county.id + "\">" + county.name + "</option>"
    $("#location_county_id").html items.join("")
    $("#location_county_id").removeAttr("disabled")

$(document).ready ->
    $("#location_state_id").change ->
      updateCounties()
java